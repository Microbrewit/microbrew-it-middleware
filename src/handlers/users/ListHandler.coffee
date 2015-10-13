###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/users', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Users"
			navigationState: 'users'
			user: user
			html: @renderer.render
				template: "public/templates/users/index.jade"
				data: 
					type:'users' 
					headline: @renderer.headline 'Brewers'
					mode: 'list'
					results: results

					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.users.get req.params, (err, res, body) => 
			req.params.size ?= body.users.length
			reply @render(
				body.users, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.users.length)
			)
		, req.token


module.exports = Handler


