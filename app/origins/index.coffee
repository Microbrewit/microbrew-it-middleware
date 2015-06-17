exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/origins' 
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
			path: '/origins/{id}'
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
			path: '/origins/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/origins/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/origins/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/origins'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/origins/{id}/delete'
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
			title: " origins - Origins"
			navigationState: 'origins'
			user: user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline 'origins', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: response.origins

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.origins[0].name} - origins - Origins"
			navigationState: 'origins'
			user: user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline "#{response.origins[0].name}", "#{response.origins[0].type}"
					mode: 'single'
					item: response.origins[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.origins[0].name} - origins - Ingredients"
			navigationState: 'origins'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline "#{response.origins[0].name}", "#{response.origins[0].type}"
					mode: 'edit'
					item: response.origins[0]
					action: "/origins/#{response.origins[0].originId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - origins - Ingredients"
			navigationState: 'ingredients'
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline "Add origin"
					mode: 'edit'
					item: {}
					action: "/origins"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.originId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/origins/#{req.payload.originId}")
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
			reply.redirect("/origins/#{response.originId}")
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
			reply.redirect("/origins")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
