exports.getRoutes = () ->
	return [{
			method: 'GET'
			path:'/'
			config: 
            	handler: handler
            	auth: 
                	mode: 'try',
                	strategy: 'session'
	}]

handler = (req, reply) =>
	reply @renderer.page
		title: "Home of homebrewers"
		navigationState: 'home'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			data:
				user: req?.auth?.credentials?.user
			template: "#{__dirname}/home.jade"