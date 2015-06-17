exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/breweries' 
			config: 
				handler: list
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
		{
			method: 'GET'
			path: '/breweries/{id}'
			config: 
				handler: show
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
	]

list = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		console.log response.breweries
		reply @renderer.page
			title: "Breweries - Breweries"
			navigationState: 'breweries'
			user: req?.auth?.credentials?.user
			html: @renderer.render
				template: "public/templates/breweries/index.jade"
				data: 
					type:'breweries'
					headline: @renderer.headline 'Breweries', 'Breweries, Microbreweries, Nanobreweries'
					mode: 'list'
					results: response.breweries

show = (req, reply) =>
	if(req.auth.isAuthenticated)
		user = req.auth.credentials.user
	@get req.url.path, (status, response) =>
		reply @renderer.page
			title: "#{response.breweries[0].name} - breweries - Breweries"
			navigationState: 'breweries'
			user: req?.auth?.credentials?.user
			html: @renderer.render
				template: "public/templates/breweries/index.jade"
				data: 
					type:'breweries'
					headline: @renderer.headline "#{response.breweries[0].name}", "#{response.breweries[0].type}"
					mode: 'single'
					item: response.breweries[0]

