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
		if(status is 200)
			url = "/users/" + response.username
			console.log url
			@get url, (sta, res) =>
				console.log sta
				if(sta is 200)
					credentials =
						toke: response
						user: res.users[0]
					req.auth.session.set credentials
					reply '<h2>Welcome </h2><a href="/logout">Logout</a>'
				else
					reply '<h2> Failed duh duh duuuuuhhh</h2>'
		else 
			reply '<h2> Failed duh duh duuuuuhhh</h2>'

#Logout the use, by clearing the session.
logoutHandler = (req, reply) =>
	credentials = req.auth.credentials
	console.log credentials
	req.auth.session.clear()
	html = @renderer.header navigationElement, "Account"
	html += "Logout"
	html += @renderer.footer()

	reply html
