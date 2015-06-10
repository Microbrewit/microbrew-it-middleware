exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/login' 
			config:
				handler: loginGetHandler
		}
		{
			method: 'GET'
			path: '/logout'
			config: 
            	handler: logoutHandler
            	auth: 
                	mode: 'try',
                	strategy: 'session'
            
           	 	plugins: 
                	'hapi-auth-cookie': 
                    	redirectTo: '/'   
		}
		{
			method: 'POST'
			path: '/login'
			config: 
            	handler: loginPostHandler
            	auth: 
                	mode: 'try',
                	strategy: 'session'
            
           	 	plugins: 
                	'hapi-auth-cookie': 
                    	redirectTo: false                            
		}
	]

navigationElement = 'account'

loginGetHandler = (req, reply) =>
	html = @renderer.header navigationElement, "Account"
	html += @renderer.render
		data: 
			results: ""
		template: "#{__dirname}/login.jade"
	html += @renderer.footer()

	reply html

loginPostHandler = (req, reply) =>
	input = 
		username : req.payload.username
		password : req.payload.password
		grant_type: "password"
	@post '/token', input, (status, response) =>
		
		html = @renderer.header navigationElement, "Account"
		html += "Login Post"
		html += @renderer.footer()
		session = 
			user: req.payload.username
			token: response.access_token
		req.auth.session.set(response)
		console.log req.auth
		reply '<h2>Welcome </h2><a href="/logout">Logout</a>'

logoutHandler = (req, reply) =>
	credentials = req.auth.credentials
	console.log credentials
	req.auth.session.clear()
	html = @renderer.header navigationElement, "Account"
	html += "Logout"
	html += @renderer.footer()

	reply html
