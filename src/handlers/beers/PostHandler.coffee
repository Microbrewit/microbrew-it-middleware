###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		# return [
		# 	{

		# 	}
		# ]
		super { path: '/beers', method: 'POST' }

	# Check that recipe contents are present
	verifyRecipe: () ->

	onRequest: (request, reply) ->
		


module.exports = SingleHandler
