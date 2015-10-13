###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/others/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - others - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.others.get request.params, (err, res, body) => 
			reply @render(body.others[0], request.user)
		, request.token


module.exports = SingleHandler
