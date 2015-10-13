RouteHandler = require '../../core/RouteHandler'

###
@author Torstein Thune
@copyright 2015 Microbrew.it
###
class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/logout', method: 'GET' }

	onRequest: (req, reply) ->
		req.raw.auth.session.clear()
		reply.redirect('/')

module.exports = Handler
