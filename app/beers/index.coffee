exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/beers' 
			handler: (req, reply) -> 
				try
					handler(req, reply)
				catch e 
					console.log e
		}
		{
			method: 'GET'
			path: '/beers/{id}'
			handler: singleHandler
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

handler = (req, reply) =>
	try
		@get req.url.path, (status, response) =>
			console.log 'here?'
			pagination = makePrevNextLink(req.url.query, req.url.pathname, response.beers.length)
			reply @renderer.page
				title: "Beers"
				navigationState: 'beers'
				user: req?.auth?.credentials?.user
				html: @renderer.render
					template: "public/templates/beers/index.jade"
					data: 
						headline: @renderer.headline 'Beers'
						mode: 'list'
						user: req?.auth?.credentials?.user
						results: response.beers
						nextPage: pagination.next
						prevPage: pagination.prev
		, (err) ->
			console.log 'error here?'
			reply 'ERROR'
	catch e 
		reply 'ERROR 2'
	# @get req.url.path, (status, response) =>
		
	# 	reply @renderer.page
	# 		head: @renderer.head 'Beers'
	# 		navigation: @renderer.navigation 'beers'
	# 		headline: @renderer.headline 'Beers'
	# 		html: @renderer.render
	# 			template: "#{__dirname}/beers.jade"
	# 			data: 
	# 				results: response.beers
	# 				nextPage: pagination.next
	# 				prevPage: pagination.prev


singleHandler = (req, reply) =>
	@get req.url.path, (status, response) =>
		reply response