exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/beers' 
			config:
				handler: (req, reply) -> 
					try
						handler(req, reply)
					catch e 
						console.log e
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  

		}
		{
			method: 'GET'
			path: '/beers/{id}'
			config:
				handler: singleHandler
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 

		}
		{
			method: 'GET'
			path: '/beers/add'
			config:
				handler: (req, reply) ->
					showRecipeApp(req, reply, "Add new beer", 'recipe')
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
		{
			method: 'POST'
			path: '/beers/add'
			config:
				handler: addBeer
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
		{
			method: 'GET'
			path: '/beers/{id}/edit'
			config:
				handler: (req, reply) ->
					showRecipeApp(req, reply, "Edit #{req.params.id}", 'beers')
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
		{
			method: 'GET'
			path: '/beers/{id}/fork'
			config:
				handler: (req, reply) ->
					showRecipeApp(req, reply, "Fork #{req.params.id}", 'beers')
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
			
	]

addBeer = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: '/beers'

	console.log req.payload.custom
	console.log req.auth.isAuthenticated
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@post query, (status, response) =>
		if status > 200 and status < 300
			console.log response	
			console.log "REDIRECT: to /beers/#{response.id}"
			reply.redirect("/beers/#{response.id}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

	# Serve Angular files

showRecipeApp = (req, reply, title, navigationState) =>
	reply @renderer.page
		title: title
		navigationState: navigationState
		user: req?.auth?.credentials?.user
		html: @renderer.render
			template: "public/templates/beers/index.jade"
			data:
				type:'beers'
				mode: 'add'
				user: req?.auth?.credentials?.user

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

handler = (req, reply) =>
	try
		@get req.url.path, (status, response) =>
			console.log 'here?'
			pagination = makePrevNextLink(req.url.query, req.url.pathname, response.beers.length)
			reply @renderer.page
				title: "Beers"
				navigationState: 'beers'
				user: req?.auth?.credentials?.user
				html: @renderer.render
					template: "public/templates/beers/index.jade"
					data:
						type:'beers'
						headline: @renderer.headline 'Beers'
						mode: 'list'
						user: req?.auth?.credentials?.user
						results: response.beers
						nextPage: pagination.next
						prevPage: pagination.prev
		, (err) ->
			console.log 'error here?'
			reply 'ERROR'
	catch e 
		reply 'ERROR 2'
	# @get req.url.path, (status, response) =>
		
	# 	reply @renderer.page
	# 		head: @renderer.head 'Beers'
	# 		navigation: @renderer.navigation 'beers'
	# 		headline: @renderer.headline 'Beers'
	# 		html: @renderer.render
	# 			template: "#{__dirname}/beers.jade"
	# 			data: 
	#				type:'beer' 
	# 				results: response.beers
	# 				nextPage: pagination.next
	# 				prevPage: pagination.prev


singleHandler = (req, reply) =>
	@get req.url.path, (status, response) =>
		beer = response.beers[0]
		brewers = []
		for brewer in beer.brewers
			brewers.push "<a href=\"users/#{brewer.username}\">#{brewer.username}</a>"
		reply @renderer.page
			title: beer.name
			navigationState: 'beers'
			user: req?.auth?.credentials?.user
			html: @renderer.render
				template: "public/templates/beers/index.jade"
				data:
					type:'beers'
					subNavState: 'recipe'
					subnav: [
						{href: "/beers/#{beer.id}", label: 'Recipe', activeState: 'recipe'}
						{href: "/beers/#{beer.id}/edit", label: 'Edit', activeState: 'edit'}
						{href: "/beers/#{beer.id}/fork", label: 'Fork', activeState: 'fork'}
					]
					headline: 
						headline: beer.name
						subheader: "<a href=\"beerstyles/#{beer.beerStyle.beerStyleId}\">#{beer.beerStyle.name}</a><br /> <small>by #{brewers.join(',')}</small>"
						# minidisplay:
						# 	results: beer.brewers
					mode: 'single'
					user: req?.auth?.credentials?.user
					item: beer