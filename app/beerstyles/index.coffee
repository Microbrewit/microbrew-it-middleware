exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/beerstyles' 
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
			path: '/beerstyles/{id}'
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
			path: '/beerstyles/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/beerstyles/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/beerstyles/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/beerstyles'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/beerstyles/{id}/delete'
			config: 
				handler: performDelete
				auth: 'session'
		}

	]

list = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		console.log response.beerStyles
		reply @renderer.page
			title: " beerStyles - Beer Styles"
			navigationState: 'beerStyles'
			user: user
			html: @renderer.render
				template: "public/templates/beerStyles/index.jade"
				data: 
					headline: @renderer.headline 'beerStyles', ''
					mode: 'list'
					results: response.beerStyles

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.beerStyles[0].name} - beerStyles - Beer Styles"
			navigationState: 'beerStyles'
			user: user
			html: @renderer.render
				template: "public/templates/beerStyles/index.jade"
				data: 
					headline: @renderer.headline "#{response.beerStyles[0].name}", "#{response.beerStyles[0].type}"
					mode: 'single'
					item: response.beerStyles[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.beerStyles[0].name} - beerStyles - Beer Styles"
			navigationState: 'beerStyles'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/beerStyles/index.jade"
				data: 
					headline: @renderer.headline "#{response.beerStyles[0].name}", "#{response.beerStyles[0].type}"
					mode: 'edit'
					item: response.beerStyles[0]
					action: "/beerStyles/#{response.beerStyles[0].beerstyleId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - beerStyles - Ingredients"
			navigationState: 'beerStyles'
			html: @renderer.render
				template: "public/templates/beerStyles/index.jade"
				data: 
					headline: @renderer.headline "Add beerstyle"
					mode: 'edit'
					item: {}
					action: "/beerStyles"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.beerstyleId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/beerStyles/#{req.payload.beerstyleId}")
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
			reply.redirect("/beerStyles/#{response.beerstyleId}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

performDelete = (req, reply) =>
	query =
		headers: 
			accept: "application/json"
		url: req.url.path.substring(0,req.url.path.length - 7);
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@delete query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			console.log response	
			reply.redirect("/beerStyles")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
