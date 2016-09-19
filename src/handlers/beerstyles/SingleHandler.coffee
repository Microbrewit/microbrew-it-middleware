###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/beerstyles/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - beerstyles - Ingredients"
			navigationState: 'beerstyles'
			user: user
			html: @renderer.render
				template: "public/templates/beerstyles/index.jade"
				data: 
					type:'beerstyles' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.beerStyles.get request.params, (err, res, body) => 
			reply @render(body.beerStyles[0], request.user)
		, request.token


module.exports = SingleHandler
