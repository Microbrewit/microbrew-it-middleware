###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/suppliers', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Suppliers"
			navigationState: ''
			user: user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline 'Suppliers'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.suppliers.get req.params, (err, res, body) => 
			req.params.size ?= body.suppliers.length
			reply @render(
				body.suppliers, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.suppliers.length)
			)
		, req.token


module.exports = Handler


