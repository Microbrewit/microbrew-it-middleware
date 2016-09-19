###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/beerstyles', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Beer Styles"
			navigationState: 'beerstyles'
			user: user
			html: @renderer.render
				template: "public/templates/beerstyles/index.jade"
				data: 
					type:'beerstyles' 
					headline: @renderer.headline 'Beer styles'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.beerStyles.get req.params, (err, res, body) => 
			req.params.size ?= body.beerStyles.length
			reply @render(
				body.beerStyles, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.beerStyles.length)
			)
		, req.token


module.exports = Handler


