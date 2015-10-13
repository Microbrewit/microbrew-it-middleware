###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/glasses/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - glasses - Ingredients"
			navigationState: 'other'
			user: user
			html: @renderer.render
				template: "public/templates/glasses/index.jade"
				data: 
					type:'glasses' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.glasses.get request.params, (err, res, body) => 
			reply @render(body.glasses[0], request.user)
		, request.token


module.exports = SingleHandler
