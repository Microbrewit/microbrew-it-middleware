###
@author Torstein Thune
@copyright 2015 Microbrew.it
###

querystring = require 'querystring'
RouteHandler = require '../../core/RouteHandler'
jwt = require 'jwt-decode'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super [
			{
				method: 'GET'
				path:'/login'
			}
			{
				method: 'POST'
				path: '/login'
				handler: @onPost                         
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
		if req.user
			reply.redirect '/'
		else
			reply @render()

	onPost: (req, reply) =>

		# Check if we have a referer page (next)
		referer = req.headers.referer.split('?')
		next = (querystring.parse referer[1]).next
		next = '/' if next is '' or not next
		
		if req.auth.isAuthenticated
			reply.redirect next
		else

			@api.http.authenticate req.payload.username, req.payload.password, (err, res, token) =>
				if token.access_token
					decoded = jwt(token.access_token)
					console.log decoded

					req.auth.session.set 
						token: token
						user: 
							username: decoded.sub
							gravatar: null
							settings: {}
							
					reply.redirect next
					# @api.users.get({ id: decoded.sub }, (err, res, user) ->
					# 	console.log user
					# 	# user = user.users[0]

					# )
				else
					reply @render()


module.exports = SingleHandler
