exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/hops' 
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
			path: '/hops/{id}'
			config: 
				handler: show
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
		{
			method: 'GET'
			path: '/hops/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/hops/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/hops/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/hops'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/hops/{id}/delete'
			config: 
				handler: performDelete
				auth: 'session'
		}

	]

list = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: " hops - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					headline: @renderer.headline 'Hops', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: response.hops
					subNavState: 'hops'
					subnav: [
						{href: '/fermentables', label: 'Fermentables', activeState: 'fermentables'}
						{href: '/hops', label: 'Hops', activeState: 'hops'}
						{href: '/yeasts', label: 'Yeasts', activeState: 'yeasts'}
						{href: '/others', label: 'Others', activeState: 'others'}
						{action: '/search/ingredients', label: 'Search', activeState: 'search'}
					]

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.hops[0].name} - hops - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					headline: @renderer.headline "#{response.hops[0].name}", "#{response.hops[0].type}"
					mode: 'single'
					item: response.hops[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.hops[0].name} - hops - Ingredients"
			navigationState: 'ingredients'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					headline: @renderer.headline "#{response.hops[0].name}", "#{response.hops[0].type}"
					mode: 'edit'
					item: response.hops[0]
					action: "/hops/#{response.hops[0].hopId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - hops - Ingredients"
			navigationState: 'ingredients'
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					headline: @renderer.headline "Add hop"
					mode: 'edit'
					item: {}
					action: "/hops"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.hopId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/hops/#{req.payload.hopId}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"



performNew = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
	
	console.log req.payload.custom
	console.log req.auth.isAuthenticated
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"


	@post query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			console.log response	
			reply.redirect("/hops/#{response.hopId}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

performDelete = (req, reply) =>
	query =
		headers: 
			accept: "application/json"
		url: req.url.path.substring(0,req.url.path.length - 7);
	console.log "ferm: " + query.url
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@delete query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			console.log response	
			reply.redirect("/hops")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
