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
	reply @renderer.page
		title: "Home of homebrewers"
		navigationState: 'home'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			data:
				user: req?.auth?.credentials?.user
			template: "#{__dirname}/home.jade"