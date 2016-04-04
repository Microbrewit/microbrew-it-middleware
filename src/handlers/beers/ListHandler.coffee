###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/beers', method: 'GET' }

	render: (results, user, pagination) ->

		return @renderer.page
			title: "Beers"
			user: user
			html: @renderer.render
				template: "public/templates/beers/index.jade"
				data: 
					type:'beers' 
					headline: @renderer.headline 'Beers'
					mode: 'list'
					results: results
					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.beers.get req.params, (err, res, body) => 
			req.params.size ?= body.beers.length
			reply @render(
				body.beers, 
				req.user, 
				@makePrevNextLink(req.params, req.raw.url.pathname, body.beers.length)
			)
		, req.token


module.exports = Handler


