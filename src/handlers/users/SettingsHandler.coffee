###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/users/{id}/settings', method: 'GET' }

	render: (item, user) ->
		return @renderer.page
			title: "Settings - #{item.name}"
			navigationState: 'account'
			user: user
			html: @renderer.render
				template: "public/templates/users/index.jade"
				data: 
					type:'account' 
					headline: @renderer.headline "#{user.username}", "Settings"
					mode: 'settings'
					item: item

	onRequest: (request, reply) ->
		@api.users.get { id: request.user.username }, (err, res, body) => 
			reply @render(body.users[0], request.user)
		, request.token


module.exports = SingleHandler
