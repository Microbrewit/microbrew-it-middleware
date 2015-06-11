querystring = require('querystring');

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

# Gets the login page
loginGetHandler = (req, reply) =>
	html = @renderer.header navigationElement, "Account"
	html += @renderer.render
		data: 
			results: ""
		template: "#{__dirname}/login.jade"
	html += @renderer.footer()

	reply html
# Sends a post to the api logging ing the user and starting a session.
loginPostHandler = (req, reply) =>
	body = 
		username : req.payload.username
		password : req.payload.password
		grant_type: "password"
	
	query = 
		headers:
			'Content-Type':'application/x-www-form-urlencoded'
		body: querystring.stringify body
		url: '/token'

	@post query, (status, response) =>	
		html = @renderer.header navigationElement, "Account"
		html += "Login Post"
		html += @renderer.footer()

		req.auth.session.set response 
		console.log req.auth
		reply '<h2>Welcome </h2><a href="/logout">Logout</a>'
#Logout the use, by clearing the session.
logoutHandler = (req, reply) =>
	credentials = req.auth.credentials
	console.log credentials
	req.auth.session.clear()
	html = @renderer.header navigationElement, "Account"
	html += "Logout"
	html += @renderer.footer()

	reply html
