exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/search' 
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
	if req.query?.query
		@get req.url.path, (status, response) =>
			results = []
			for item in response.hits.hits
				resultItem = item._source
				resultItem.score = item._score
				results.push resultItem
			console.log response
			console.log results

			handler(req, reply, results, req.query.query, response.hits.total)
	else
		handler(req,reply)

handler = (req, reply, results = undefined, query, hits) =>
	reply @renderer.page
		title: "Search"
		navigationState: 'search'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			template: "public/templates/search/index.jade"
			data: 
				type:'search' 
				headline: @renderer.headline "Search"
				results: results
				query: query
				hits: hits