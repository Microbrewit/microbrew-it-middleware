###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/breweries/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - breweries - Ingredients"
			navigationState: 'breweries'
			user: user
			html: @renderer.render
				template: "public/templates/breweries/index.jade"
				data: 
					type:'breweries' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.breweries.get request.params, (err, res, body) => 
			reply @render(body.breweries[0], request.user)
		, request.token


module.exports = SingleHandler
