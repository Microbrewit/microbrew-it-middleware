###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/glasses', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Glassware"
			navigationState: ''
			user: user
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline 'Glassware'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.glasses.get req.params, (err, res, body) => 
			req.params.size ?= body.glasses.length
			reply @render(
				body.glasses, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.glasses.length)
			)
		, req.token


module.exports = Handler


