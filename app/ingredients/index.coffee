exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/ingredients' 
			config: 
				handler: handler
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
		{
			method: 'GET'
			path:'/search/ingredients' 
			config: 
				handler: searchHandler
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
	]

searchHandler = (req, reply) =>
	@get req.url.path, (status, response) =>
		results = []
		for item in response.hits.hits
			resultItem = item._source
			resultItem.score = item._score
			results.push resultItem
		console.log response
		console.log results

		handler(req, reply, results, req.query.query, response.hits.total)

handler = (req, reply, results = undefined, query, hits) =>
	reply @renderer.page
		title: "Ingredients"
		navigationState: 'ingredients'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			template: "public/templates/ingredients/index.jade"
			data: 
				type:'ingredients' 
				headline: @renderer.headline "Ingredients", "Malt, hops, yeasts and more"
				mode: 'single'
				subNavState: 'search'
				subnav: [
					{href: '/fermentables', label: 'Fermentables', activeState: 'fermentables'}
					{href: '/hops', label: 'Hops', activeState: 'hops'}
					{href: '/yeasts', label: 'Yeasts', activeState: 'yeasts'}
					{href: '/others', label: 'Others', activeState: 'others'}
					{action: '/search/ingredients', label: 'Search', activeState: 'search'}
				]
				results: results
				query: query
				hits: hits
				user: req?.auth?.credentials?.user