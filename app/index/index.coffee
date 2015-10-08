exports.getRoutes = () ->
	return [{
			method: 'GET'
			path:'/'
			config: 
				handler: handler
				auth: 
					mode: 'try',
					strategy: 'session'
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false 
	}]

handler = (req, reply) =>
	console.log '/ handler'
	console.log req?.auth?.credentials?.user

	@get '/beers', (status, response) =>
		reply @renderer.page
			title: "Home of homebrewers"
			navigationState: 'home'
			user: req?.auth?.credentials?.user
			html: @renderer.render
				template: "#{__dirname}/home.jade"
				data:
					user: req?.auth?.credentials?.user
					results: response.beers