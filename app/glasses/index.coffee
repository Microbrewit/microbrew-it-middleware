exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/glasses' 
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
			path: '/glasses/{id}'
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
			path: '/glasses/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/glasses/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/glasses/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/glasses'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/glasses/{id}/delete'
			config: 
				handler: performDelete
				auth: 'session'
		}

	]

list = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		console.log response.glasses
		reply @renderer.page
			title: " glasses - Glasses"
			navigationState: 'glasses'
			user: user
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline 'glasses', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: response.glasses

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.glasses[0].name} - Glasses - Glasses"
			navigationState: 'glasses'
			user: user
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline "#{response.glasses[0].name}", "#{response.glasses[0].type}"
					mode: 'single'
					item: response.glasses[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.glasses[0].name} - Glasses - Glasses"
			navigationState: 'ingredients'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline "#{response.glasses[0].name}", "#{response.glasses[0].type}"
					mode: 'edit'
					item: response.glasses[0]
					action: "/glasses/#{response.glasses[0].glassId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - Glasses - Glasses"
			navigationState: 'ingredients'
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline "Add glass"
					mode: 'edit'
					item: {}
					action: "/glasses"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.glassId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/glasses/#{req.payload.glassId}")
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
			reply.redirect("/glasses/#{response.glassId}")
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
			reply.redirect("/glasses")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
