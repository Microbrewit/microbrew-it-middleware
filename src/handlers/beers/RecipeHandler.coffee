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
		]

	# Show the recipe app
	render: (user, title, navigationState) ->
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
