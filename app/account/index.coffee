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
			
				plugins: 
					'hapi-auth-cookie': {}                         
		}
		{
			method: 'GET'
			path: '/account/settings'
			config: 
				handler: showSettings
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false
		}
		{
			method: 'GET'
			path: '/account/beers'
			config: 
				handler: showBeers
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
		}
		{
			method: 'GET'
			path: '/account'
			config: 
				handler: showBeers
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: '/account/beers' 
		}
		{
			method: 'GET'
			path: '/account/breweries'
			config: 
				handler: showBreweries
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
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
	reply @renderer.page
		title: "Login"
		navigationState: 'login'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			template: "public/templates/account/login.jade"
			data: 	
				headline: 
					headline: 'Login'

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
					reply @renderer.page
						title: "Login"
						navigationState: 'login'
						user: req?.auth?.credentials?.user
						html: @renderer.render
							template: "public/templates/account/login.jade"
							data: 
								error: true
								headline: 
									headline: 'Login'
		else 
			reply @renderer.page
				title: "Login"
				navigationState: 'login'
				user: req?.auth?.credentials?.user
				html: @renderer.render
					template: "public/templates/account/login.jade"
					data: 
						error: true
						headline: 
							headline: 'Login'

#Logout the use, by clearing the session.
logoutHandler = (req, reply) =>
	req.auth.session.clear()
	reply.redirect('/')

# @todo implement user settings
showSettings = (req, reply) =>
	user = req?.auth?.credentials?.user

	if user
		reply @renderer.page
			title: "Settings"
			navigationState: 'settings'
			user: user
			html: @renderer.render
				template: "public/templates/account/settings.jade"
				data:
					type: 'account'
					user: user
					headline: 
						headline: user.username
					subNavState: 'settings'
					subnav: [
						{href: "/account/beers", label: 'My Recipes', activeState: 'recipes'}
						{href: "/account/breweries", label: 'My Breweries', activeState: 'breweries'}
						{href: "/account/settings", label: 'Settings', activeState: 'settings'}
						{href: "/logout", label: 'Logout', activeState: 'logout'}
					]
	else 
		reply @renderer.page
			title: 'You need to be logged in'
			html: @renderer.render
				template: "public/templates/error.jade"
				data:
					headline: 
						headline: 'Please log in'
						subheader: 'You need to log in to change settings'

showBeers = (req, reply) =>
	user = req?.auth?.credentials?.user

	if user
		@get "/users/#{user.username}", (status, response) =>
			reply @renderer.page
				title: "Settings"
				navigationState: 'settings'
				user: user
				html: @renderer.render
					template: "public/templates/account/list.jade"
					data:
						type: 'account'
						user: user
						results: response.users[0].beers
						headline: 
							headline: user.username
						subNavState: 'recipes'
						subnav: [
							{href: "/account/beers", label: 'My Recipes', activeState: 'recipes'}
							{href: "/account/breweries", label: 'My Breweries', activeState: 'breweries'}
							{href: "/account/settings", label: 'Settings', activeState: 'settings'}
							{href: "/logout", label: 'Logout', activeState: 'logout'}
						]

# @todo implement user settings
showBreweries = (req, reply) =>
	user = req?.auth?.credentials?.user

	if user
		@get "/users/#{user.username}", (status, response) =>
			reply @renderer.page
				title: "Settings"
				navigationState: 'settings'
				user: user
				html: @renderer.render
					template: "public/templates/account/list.jade"
					data:
						type: 'account'
						user: user
						results: response.users[0].breweries
						headline: 
							headline: user.username
						subNavState: 'breweries'
						subnav: [
							{href: "/account/beers", label: 'My Recipes', activeState: 'recipes'}
							{href: "/account/breweries", label: 'My Breweries', activeState: 'breweries'}
							{href: "/account/settings", label: 'Settings', activeState: 'settings'}
							{href: "/logout", label: 'Logout', activeState: 'logout'}
						]

updateSettings = (req, reply) =>
