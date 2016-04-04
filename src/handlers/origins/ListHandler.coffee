###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/origins', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Origins"
			navigationState: ''
			user: user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline 'Origins'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.origins.get req.params, (err, res, body) => 
			req.params.size ?= body.origins.length
			reply @render(
				body.origins, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.origins.length)
			)
		, req.token


module.exports = Handler


