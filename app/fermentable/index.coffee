exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/fermentables' 
			config: 
				handler: list
				auth: 'session'

		}
		{
			method: 'GET'
			path: '/fermentables/{id}'
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
			path: '/fermentables/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/fermentables/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/fermentables/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/fermentables'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/fermentables/{id}/delete'
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
			title: " Fermentables - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/gridList.jade"
				data: 
					headline: @renderer.headline 'Fermentables', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: response.fermentables

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.fermentables[0].name} - Fermentables - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/fermentables/index.jade"
				data: 
					headline: @renderer.headline "#{response.fermentables[0].name}", "#{response.fermentables[0].type}"
					mode: 'single'
					item: response.fermentables[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.fermentables[0].name} - Fermentables - Ingredients"
			navigationState: 'ingredients'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/fermentables/index.jade"
				data: 
					headline: @renderer.headline "#{response.fermentables[0].name}", "#{response.fermentables[0].type}"
					mode: 'edit'
					item: response.fermentables[0]

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - Fermentables - Ingredients"
			navigationState: 'ingredients'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/fermentables/index.jade"
				data: 
					headline: @renderer.headline "Add Fermentable"
					mode: 'edit'
					item: {}

performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.fermentableId

	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/fermentables/#{req.payload.fermentableId}")
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
			reply.redirect("/fermentables/#{response.fermentableId}")
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
			reply.redirect("/fermentables")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
