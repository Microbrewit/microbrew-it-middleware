exports.getRoutes =  ->
	return [
		{
			method: 'GET'
			path:'/api/{p*}' 
			config: 
				handler: getHandler
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
		{
			method: 'POST'
			path: '/api/{p*}'
			config: 
				handler: postHandler
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false
		}
	]

formatUrl = (url) ->
	return (url.split('/api'))[1]

getHandler = (req, reply) =>
	console.log 'GET'
	console.log "GET #{formatUrl(req.url.path)}"
	@get formatUrl(req.url.path), (status, response) ->
		reply response

postHandler = (req, reply) =>
	console.log 'POST'
	query = 
		headers:
			"content-type": "application/json"
			accept: "application/json"
		body: JSON.stringify(req.payload)
		url: formatUrl(req.url.path)

	console.log req.payload

	if(req.auth.isAuthenticated)
		query.headers['Authorization'] = "Bearer #{req.auth.credentials.token.access_token}"

	console.log query.headers
	#console.log query.body
	console.log req.url.path

	@post query, (status, response) =>
		if status > 200 and status < 300
			#console.log response	
			console.log "REDIRECT: to /beers/#{response.id}"
			reply.redirect("#{query.url}/#{response.id}")
		else
			reply "<div>#{status}</div><div>#{JSON.stringify(response)}</div>"

