exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/others' 
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
			path: '/others/{id}'
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
			path: '/others/{id}/edit'
			config:
				handler: showEdit
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/others/{id}'
			config: 
				handler: performEdit
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/others/new'
			config: 
				handler: showNew
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/others'
			config: 
				handler: performNew
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/others/{id}/delete'
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
			title: " others - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline 'Others', 'Fruits, spices, miscellaneous'
					mode: 'list'
					results: response.others
					subNavState: 'others'
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
			title: "#{response.others[0].name} - others - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline "#{response.others[0].name}", "#{response.others[0].type}"
					mode: 'single'
					item: response.others[0]

showEdit = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		reply @renderer.page
			title: "#{response.others[0].name} - others - Ingredients"
			navigationState: 'ingredients'
			user: req.auth.credentials.user
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline "#{response.others[0].name}", "#{response.others[0].type}"
					mode: 'edit'
					item: response.others[0]
					action: "/others/#{response.others[0].otherId}"

showNew = (req, reply) =>
	reply @renderer.page
			title: "Add - others - Ingredients"
			navigationState: 'ingredients'
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline "Add other"
					mode: 'edit'
					item: {}
					action: "/others"


performEdit = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.otherId

	if req.auth.isAuthenticated and req.auth.credentials?.token?.access_token
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/others/#{req.payload.otherId}")
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
			reply.redirect("/others/#{response.otherId}")
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
			reply.redirect("/others")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
