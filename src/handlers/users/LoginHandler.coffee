###
@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		return [
			{
				method: 'GET'
				path:'/login' 
				config:
					handler: @onGet
			}
			{
				method: 'POST'
				path: '/login'
				config: 
					handler: @onPost
				
					plugins: 
						'hapi-auth-cookie': {}                         
			}
		]

	render: (item, user) ->
		return @renderer.page
			title: "Login"
			html: @renderer.render
				template: "public/templates/account/login.jade"
				data: 
					type:'account' 
					headline: @renderer.headline "Login"

	onGet: (req, reply) =>
		if req.auth.isAuthenticated
			reply.redirect '/'
		else
			reply @render()

	onPost: (req, reply) =>
		console.log req
		if req.auth.isAuthenticated
			reply.redirect '/'
		else
			@api.http.authenticate req.payload.username, req.payload.password, (err, res, token) =>
					if token.username
						@api.users.get({ id: token.username }, (err, res, user) ->
							user = user.users[0]

							req.auth.session.set 
								token: token
								user: 
									username: user.username
									gravatar: user.gravatar
									settings: user.settings
							reply.redirect '/'
						)


module.exports = SingleHandler
