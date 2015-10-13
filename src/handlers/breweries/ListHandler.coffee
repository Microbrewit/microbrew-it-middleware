###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/breweries', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Breweries"
			navigationState: ''
			user: user
			html: @renderer.render
				template: "public/templates/breweries/index.jade"
				data: 
					type:'breweries' 
					headline: @renderer.headline 'Breweries'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.breweries.get req.params, (err, res, body) => 
			req.params.size ?= body.breweries.length
			reply @render(
				body.breweries, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.breweries.length)
			)
		, req.token


module.exports = Handler


