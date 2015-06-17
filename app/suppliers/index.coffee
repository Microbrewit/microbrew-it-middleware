exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/suppliers' 
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
			path: '/suppliers/{id}'
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
			path: '/suppliers/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/suppliers/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/suppliers/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/suppliers'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/suppliers/{id}/delete'
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
			title: "suppliers - suppliers"
			navigationState: 'suppliers'
			user: user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline 'suppliers', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: response.suppliers

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.suppliers[0].name} - Suppliers - Suppliers"
			navigationState: 'suppliers'
			user: user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline "#{response.suppliers[0].name}", "#{response.suppliers[0].type}"
					mode: 'single'
					item: response.suppliers[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.suppliers[0].name} - suppliers - Suppliers"
			navigationState: 'suppliers'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline "#{response.suppliers[0].name}", "#{response.suppliers[0].type}"
					mode: 'edit'
					item: response.suppliers[0]
					action: "/suppliers/#{response.suppliers[0].supplierId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - suppliers - Ingredients"
			navigationState: 'ingredients'
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline "Add supplier"
					mode: 'edit'
					item: {}
					action: "/suppliers"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.supplierId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/suppliers/#{req.payload.supplierId}")
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
			reply.redirect("/suppliers/#{response.supplierId}")
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
			reply.redirect("/suppliers")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
