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

makePrevNextLink = (query, pathname, currentResults) ->
	query = JSON.parse JSON.stringify query

	query.size ?= 50
	query.from ?= 0

	next = JSON.parse JSON.stringify query
	next.from = parseInt(query.from, 10) + parseInt(query.size,10)

	nextLink = pathname + '?'
	for key, val of next
		nextLink += "#{key}=#{val}&"



	prev = JSON.parse JSON.stringify query
	prev.from = parseInt(query.from, 10) - parseInt(query.size,10)

	if prev.from >= 0 and query.size <= currentResults
		prevLink = pathname + '?'
		for key, val of prev
			prevLink += "#{key}=#{val}&"
	else
		prevLink = undefined

	return {
		next: nextLink
		prev: prevLink
	}

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
	pagination = makePrevNextLink(req.url.query, req.url.pathname, results?.length)
	reply @renderer.page
		title: "Search"
		navigationState: 'search'
		user: req?.auth?.credentials?.user
		html: @renderer.render
			template: "public/templates/search/index.jade"
			data: 
				type:'search' 
				#headline: @renderer.headline "Search"
				results: results
				query: query
				hits: hits
				nextPage: pagination.next
				prevPage: pagination.prev