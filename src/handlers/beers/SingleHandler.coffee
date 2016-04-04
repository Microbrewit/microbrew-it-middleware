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
		super super { path: '/beers/{id}', method: 'GET' }

	render: (beer, user) ->
		subNav = @_createSubNav(beer, user)
		brewers = @_getBrewers(beer)

		return @renderer.page
			title: beer.name
			navigationState: 'beers'
			user: user
			html: @renderer.render
				template: "public/templates/beers/index.jade"
				data:
					type: 'beers'
					subNavState: 'recipe'
					subnav: subNav
					headline:
						headline: beer.name
						subheader: "<a href=\"beerstyles/#{beer.beerStyle.beerStyleId}\">#{beer.beerStyle.name}</a><br /> <small>by #{brewers.join(',')}</small>"
					mode: 'single'
					user: user
					item: beer

	onRequest: (request, reply) ->
		@api.beers.get request.params, (err, res, body) =>
			reply @render(body.beers[0], request.user)
		, request.token


module.exports = SingleHandler
