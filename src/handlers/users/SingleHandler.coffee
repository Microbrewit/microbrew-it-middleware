###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/users/{id}', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - users"
			navigationState: 'users'
			user: user
			html: @renderer.render
				template: "public/templates/users/index.jade"
				data: 
					type:'users' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.users.get request.params, (err, res, body) => 
			reply @render(body.users[0], request.user)
		, request.token


module.exports = SingleHandler
