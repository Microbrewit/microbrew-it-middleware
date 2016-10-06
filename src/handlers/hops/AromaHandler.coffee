###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/hops/aroma/{aroma}', method: 'GET' }

	subNav: (user) ->
		return null

	render: (results, user, pagination, params) ->
		return @renderer.page
			title: "#{params.aroma} - Hops"
			navigationState: 'hops'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					type:'hops' 
					headline: @renderer.headline "#{params.aroma} aroma", 'Hops'
					mode: 'list'
					results: results
					subNavState: 'hops'
					subnav: @subNav(user)
					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		query = 
			partial: "hops/aromawheels/#{req.params.aroma}"
			params:
				size: if req.params.size then req.params.size else 100
				from: if req.params.from then req.params.from else 0

		@api.http.get(query, (err, res, body) =>
			reply @render(
				body.hops,
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.hops.length),
				req.params
			)
		, req.token)

		# @api.search.esSearch
		# 	params:
		# 		size: if req.params.size then req.params.size else 100
		# 		from: if req.params.from then req.params.from else 0
		# 		q: 'type:hop'
		# 		sort: 'name:asc'
				
		# , (err, res, body) =>
		# 	req.params.size ?= body.hits.hits.length
		# 	reply @render(
		# 		body.hits.hits,
		# 		req.user,
		# 		@makePrevNextLink(req.params, req.raw.url.pathname, body.hits.hits.length)
		# 	)
		# , req.token


module.exports = Handler


