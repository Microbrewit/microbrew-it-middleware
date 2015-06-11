exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/fermentables' 
			config: 
				handler: handler
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
				auth: 'session'
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

navigationElement = 'ingredients'

handler = (req, reply) =>
	console.log req.url.path
	@get req.url.path, (status, response) =>
		console.log 'hello?'
		html = @renderer.header navigationElement, "Fermentables"
		html += @renderer.render
			data: 
				results: response.fermentables
			template: "#{__dirname}/fermentables.jade"
		html += @renderer.footer()

		reply html

singleFermentableHandler = (req, reply) =>
	@get req.url.path, (status, response) =>

		html = @renderer.header navigationElement, "#{response.fermentables[0].name} - Fermentables"
		html += @renderer.render
			template: "#{__dirname}/singleFermentable.jade"
			data: 
				fermentable: response.fermentables[0] 
		html += @renderer.footer()

		reply html

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
	console.log req.payload.name
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: req.url.path
		id: req.payload.fermentableId

	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.access_token}"

	@put query, (status, response) =>
		if(status is 200 || status is 201 || status is 204)
			reply.redirect("/fermentables/#{req.payload.fermentableId}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

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
	
	console.log req.payload.custom
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