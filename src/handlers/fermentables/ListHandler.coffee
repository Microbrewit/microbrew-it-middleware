###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/fermentables', method: 'GET' }

	render: (body, user, pagination) ->
		return @renderer.page
			title: " Fermentables - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/fermentables/index.jade"
				data: 
					type:'fermentables' 
					headline: @renderer.headline 'Fermentables', 'Malts, adjuncts, sugars'
					mode: 'list'
					results: body.fermentables
					subNavState: 'fermentables'
					subnav: [
						{href: '/fermentables', label: 'Fermentables', activeState: 'fermentables'}
						{href: '/hops', label: 'Hops', activeState: 'hops'}
						{href: '/yeasts', label: 'Yeasts', activeState: 'yeasts'}
						{href: '/others', label: 'Others', activeState: 'others'}
						{action: '/search/ingredients', label: 'Search', activeState: 'search'}
					]
					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.fermentables.get req.params, (err, res, body) => 
			req.params.size ?= body.fermentables.length
			reply @render(
				body, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.fermentables.length)
			)
		, req.token


module.exports = Handler


