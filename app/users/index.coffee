exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/users'
			config:
				handler: list
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
		{
			method: 'GET'
			path: '/users/{username}'
			config:
				handler: show
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
	]

makePrevNextLink = (query, pathname, currentResults) ->
	query = JSON.parse JSON.stringify query

	query.size ?= 50
	query.from ?= 0

	next = JSON.parse JSON.stringify query
	next.from = parseInt(query.from, 10) + parseInt(query.size,10)

	nextLink = pathname + '?'
	for key, val of next
		nextLink += "#{key}=#{val}&"



	prev = JSON.parse JSON.stringify query
	prev.from = parseInt(query.from, 10) - parseInt(query.size,10)

	if prev.from >= 0 and query.size <= currentResults
		prevLink = pathname + '?'
		for key, val of prev
			prevLink += "#{key}=#{val}&"
	else
		prevLink = undefined

	return {
		next: nextLink
		prev: prevLink
	}

list = (req, reply) =>
	@get req.url.path, (status, response) =>
		pagination = makePrevNextLink(req.url.query, req.url.pathname, response.users.length)
		reply @renderer.page
			title: "Brewers"
			navigationState: 'brewers'
			user: req?.auth?.credentials?.user
			html: @renderer.render
				template: "public/templates/users/index.jade"
				data: 
					type:'users' 
					headline: @renderer.headline 'Brewers'
					mode: 'list'
					user: req?.auth?.credentials?.user
					results: response.users
					nextPage: pagination.next
					prevPage: pagination.prev

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.users[0].username} - users - Users"
			navigationState: 'brewers'
			user: user
			html: @renderer.render
				template: "public/templates/users/index.jade"
				data: 
					type:'users' 
					headline: @renderer.headline "#{response.users[0].username}", "#{response.users[0].type}"
					mode: 'single'
					item: response.users[0]
