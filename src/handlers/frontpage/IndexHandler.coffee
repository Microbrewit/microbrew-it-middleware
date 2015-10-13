RouteHandler = require '../../core/RouteHandler'

###
Index/frontpage/home

@author Torstein Thune
@copyright 2015 Microbrew.it
###
class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/', method: 'GET' }

	render: (err, res, body, user) ->
		return @renderer.page
			title: "Home of homebrewers"
			navigationState: 'home'
			user: user
			html: @renderer.render
				template: "public/templates/home.jade"
				data:
					user: user
					results: body.beers

	onRequest: (request, reply) ->
		@api.beers.get { limit: 10 }, (err, res, body) =>
			reply @render(err, res, body, request.user)
		, request.token

module.exports = Handler
