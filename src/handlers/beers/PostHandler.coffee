###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super [
			{ 
				path: '/api/beers'
				method: 'POST'
			}
			{ 
				path: '/api/beers/{id}'
				method: 'PUT'
			}
		]

	updateBeer: (req, reply) =>
		@logger.log 'wat'
		reply 'wat?'

	addBeer: (req, reply) =>
		beer = req.raw.payload

		beer.recipe.brewers = []
		beer.recipe.brewers.push 
			username: req.user.username

		beer.brewers = []
		beer.brewers.push 
			username: req.user.username

		if @verifyRecipe(beer)
			console.log 'TRY POSTING IT'
			@api.beers.post beer, (err,res,body) ->
				console.log err
				console.log body
				reply body
			, req.token
		else
			reply 'lol'

	# Check that recipe contents are present
	verifyRecipe: (recipe) ->
		# @logger.log JSON.stringify recipe, false, '\t'
		return true

	onPost: (req, reply) ->
		@logger.log 'onPost'
		@addBeer req, reply

		


module.exports = SingleHandler
