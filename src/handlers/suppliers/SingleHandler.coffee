###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/suppliers/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - suppliers - Ingredients"
			navigationState: 'other'
			user: user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data: 
					type:'suppliers' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.suppliers.get request.params, (err, res, body) => 
			reply @render(body.suppliers[0], request.user)
		, request.token


module.exports = SingleHandler
