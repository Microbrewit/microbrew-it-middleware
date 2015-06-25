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
			path:'/getloggeduser' 
			config:
				handler: loggedUser
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false
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
				# auth: 
				# 	mode: 'try',
				# 	strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': {}                         
		}
	]

navigationElement = 'account'

# Get user object for logged in user
loggedUser = (req, reply) =>
	if req?.auth?.credentials?.user
		@get("/users/#{req.auth.credentials.user.username}", (status, userObj) =>
			replyString = ''
			if req.query.callback
				replyString += "#{req.query.callback}("
			replyString += JSON.stringify(userObj.users[0])
			if req.query.callback
				replyString += ')'
			reply replyString
		)
	else
		reply JSON.stringify { error: "not authenticated" }


# Gets the login page
loginGetHandler = (req, reply) =>
	console.log 'loginGetHandler'
	html = @renderer.render
		data: 
			results: ""
		template: "#{__dirname}/login.jade"

	reply html
# Sends a post to the api logging ing the user and starting a session.
loginPostHandler = (req, reply) =>
	console.log 'loginPostHandler'
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

		if status is 200
			url = "/users/" + response.username
			@get url, (sta, res) =>
				console.log sta
				if(sta is 200)
					data =
						token: response
						user:
							username: res.users[0].username
							gravatar: res.users[0].gravatar
							settings: res.users[0].settings

					req.auth.session.set data
					reply.redirect('/')
					# reply '<h2>Welcome </h2><a href="/logout">Logout</a>'
				else
					reply '<h2> Failed duh duh duuuuuhhh</h2>'
		else 
			reply '<h2> Failed duh duh duuuuuhhh</h2>'

#Logout the use, by clearing the session.
logoutHandler = (req, reply) =>
	req.auth.session.clear()
	html = "Logout"

	reply html
