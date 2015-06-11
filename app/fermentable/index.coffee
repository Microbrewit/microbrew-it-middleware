exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/fermentables' 
			config: 
				handler: handler
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/fermentables/{id}'
			handler: singleFermentableHandler
		}
		{
			method: 'GET'
			path: '/fermentables/{id}/edit'
			config:
				handler: singleFermentableEditHandler
		}
		{
			method: 'POST'
			path: '/fermentables/{id}'
			config: 
				handler: singleFermentableEditPutHandler
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/fermentables/new'
			config: 
				handler: fermentableNewHandler
				auth: 'session'
		}
		{
			method: 'POST'
			path: '/fermentables'
			config: 
				handler: fermentablePostHandler
				auth: 'session'
		}
		{
			method: 'GET'
			path: '/fermentables/{id}/delete'
			config: 
				handler: fermentableDeleteHandler
				auth: 'session'
		}

	]

handler = (req, reply) =>
	@get req.url.path, (status, response) =>
		reply @renderer.page
			head: @renderer.head 'Fermentables - Ingredients'
			navigation: @renderer.navigation 'ingredients'
			headline: @renderer.headline 'Fermentables', 'Malts, adjuncts, sugars'
			html: @renderer.render
				template: "#{__dirname}/fermentables.jade"
				data: 
					results: response.fermentables

singleFermentableHandler = (req, reply) =>
	@get req.url.path, (status, response) =>
		reply @renderer.page
			head: @renderer.head "#{response.fermentables[0].name} - Fermentables - Ingredients"
			navigation: @renderer.navigation 'ingredients'
			headline: @renderer.headline "#{response.fermentables[0].name}", "#{response.fermentables[0].type}"
			html: @renderer.render
				template: "#{__dirname}/fermentables.single.jade"
				data: response.fermentables[0]

singleFermentableEditHandler = (req, reply) =>
	url = req.url.path.substring(0,req.url.path.length - 5)
	@get url, (status, response) =>
		html = @renderer.header navigationElement, "#{response.fermentables[0].name} - Fermentables"
		html += @renderer.render
			template: "#{__dirname}/singleFermentableEdit.jade"
			data: 
				fermentable: response.fermentables[0] 
		html += @renderer.footer()

		reply html

singleFermentableEditPutHandler = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.fermentableId

	console.log req.auth.isAuthenticated
	console.log req.auth.credentials.access_token
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.access_token}"

	console.log query.url
	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/fermentables/#{req.payload.fermentableId}")
		else
			reply "<div>#{status}</div><div>#{response}</div>"

fermentableNewHandler = (req, reply) =>
	html = @renderer.header navigationElement, "Fermentables"
	html += @renderer.render
		template: "#{__dirname}/singleFermentableNew.jade"
	html += @renderer.footer()
	reply html

fermentablePostHandler = (req, reply) =>
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
	
	console.log req.auth.isAuthenticated
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.access_token}"


	@post query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			console.log response	
			reply.redirect("/fermentables/#{response.fermentableId}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

fermentableDeleteHandler = (req, reply) =>
	query =
		headers: 
			accept: "application/json"
		url: req.url.path.substring(0,req.url.path.length - 7);
	console.log "ferm: " + query.url
	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.access_token}"

	@delete query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			console.log response	
			reply.redirect("/fermentables")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"
