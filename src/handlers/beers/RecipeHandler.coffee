###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	_getBrewers: (beer) ->
		brewers = []
		for brewer in beer.brewers
			brewers.push "<a href=\"users/#{brewer.username}\">#{brewer.username}</a>"

	_createSubNav: (beer, user) ->
		if user
			subNav = [
				{href: "/beers/#{beer.id}", label: 'Recipe', activeState: 'recipe'}
				{href: "/beers/#{beer.id}/fork", label: 'Fork', activeState: 'fork'}
			]

			if @userUtils.canEdit(user, beer)
				subNav.push {href: "/beers/#{beer.id}/edit", label: 'Edit', activeState: 'edit'}

	getRoute: () ->
		super [
			{ 
				path: '/beers/add'
				method: 'GET'
				auth: true
			}
			{ 
				path: '/beers/{id}/edit'
				method: 'GET'
				auth: true
				handler: (req, reply) => 
					@onRequest(req, reply, "Edit #{req.params.id}", 'recipe')
			}
			{ 
				path: '/beers/{id}/fork'
				method: 'GET'
				auth: true
				handler: (req, reply) => 
					@onRequest(req, reply,  "Fork #{req.params.id}", 'beers')
			}

			# The Recipe app will want some data
			# We proxy the API to avoid CORS
			# @deprecated
			{ 
				path: '/api/fermentables'
				method: 'GET'
				handler: (req, reply) => 
					@api.fermentables.get { size: 1000, callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/hops'
				method: 'GET'
				handler: (req, reply) => 
					@api.hops.get { size: 1000, callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/hops/forms'
				method: 'GET'
				handler: (req, reply) => 
					@api.hops.forms { callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/yeasts'
				method: 'GET'
				handler: (req, reply) => 
					@api.yeasts.get { size: 1000, callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/others'
				method: 'GET'
				handler: (req, reply) => 
					@api.others.get { size: 1000, callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/beerstyles'
				method: 'GET'
				handler: (req, reply) => 
					@api.beerStyles.get { size: 1000, callback: req.query.callback }, (err, res, body) ->
						reply body
			}
			# @deprecated
			{ 
				path: '/api/beers/{id}'
				method: 'GET'
				handler: (req, reply) => 
					console.log req.params.id
					@api.beers.get { id: req.params.id }, (err, res, body) ->
						reply body
			}
		]

	# Show the recipe app
	render: (user, title="Add new beer", navigationState="recipe") ->
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

	onRequest: (req, reply, title, navigationState) ->
		reply @render(req.user, title, navigationState)


module.exports = SingleHandler
