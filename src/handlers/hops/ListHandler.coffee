###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/hops', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Hops - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					type:'hops' 
					headline: @renderer.headline 'Hops'
					mode: 'list'
					results: results
					subNavState: 'hops'
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
		@api.hops.get req.params, (err, res, body) => 
			req.params.size ?= body.hops.length
			reply @render(
				body.hops, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.hops.length)
			)
		, req.token


module.exports = Handler


