###
Handler for importing BeerXML

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class ImportHandler extends RouteHandler

	getRoute: () ->
		super [
			{
				path: '/beers/import'
				method: 'GET'
				auth: true
			}
			{
				path: '/beers/import'
				method: 'POST'
				auth: true
				config:
					payload:
						maxBytes: 209715200
						output: 'string'
						parse: true
			}
		]
			
	# Show the recipe app
	render: (user, title="Add new beer", navigationState="recipe") ->
		return @renderer.page
			title: 'Import Beer'
			navigationState: 'beers'
			user: user
			html: @renderer.render
				template: "public/templates/beers/index.jade"
				data:
					type: 'beers'
					mode: 'import'
					headline:
						headline: 'Import Recipe'
						subheader: 'Import existing BeerXML'
					user: user

	renderRecipe: (user, title="Add new beer", navigationState="recipe", recipeJSON) ->
		return @renderer.page
			title: title
			navigationState: navigationState
			user: user
			html: @renderer.render
				template: "public/templates/beers/index.jade"
				data:
					type:'beers'
					mode: 'add'
					user: user
					recipe: recipeJSON

	onGet: (req, reply, title, navigationState) ->
		reply @render(req.user, title, navigationState)

	onPost: (req, reply) ->
		@api.beers.beerxml req.raw.payload.beerxml, (err, res, body) =>
			reply @renderRecipe(req.user, 'Import Beer', 'recipe', body)
		, req.token


module.exports = ImportHandler
