###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/origins/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - origins - Ingredients"
			navigationState: 'other'
			user: user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.origins.get request.params, (err, res, body) => 
			reply @render(body.origins[0], request.user)
		, request.token


module.exports = SingleHandler
