###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super [
			{ path: '/search/{query}', method: 'GET' }
			{ path: '/search/ingredients/{query}', method: 'GET' }
			{ path: '/search', method: 'GET' }
			{ path: '/search/ingredients', method: 'GET' }
		]

	render: (results, user, query, hits, pagination) ->
		@renderer.page
			title: "Search"
			navigationState: 'search'
			user: user
			html: @renderer.render
				template: "public/templates/search/index.jade"
				data: 
					user: user
					type:'search' 
					#headline: @renderer.headline "Search"
					results: results
					query: query
					hits: hits
					nextPage: pagination?.next
					prevPage: pagination?.prev

	_parseHits: (body) ->
		results = []
		for item in body.hits.hits
			resultItem = item._source
			resultItem.score = item._score
			results.push resultItem
		return results

	onRequest: (req, reply) ->
		@logger.log req.params
		if req.raw.query?.query
			@api.search.get(req.params, (err, res, body) =>
				@logger.log JSON.stringify body, false, '\t'
				hits = body.hits.total
				query = req.params.query
				results = @_parseHits(body)
				pagination = @makePrevNextLink(req.raw.url.query, req.raw.url.pathname, results.length)

				reply @render results, req.user, query, hits, pagination

			, req.token)
		else
			reply @render()


module.exports = Handler


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