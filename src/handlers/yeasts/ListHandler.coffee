###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/yeasts', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Yeasts - Ingredients"
			navigationState: 'yeasts'
			user: user
			html: @renderer.render
				template: "public/templates/yeasts/index.jade"
				data: 
					type:'yeasts' 
					headline: @renderer.headline 'Yeasts'
					mode: 'list'
					results: results
					subNavState: 'yeasts'
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
		@api.yeasts.get req.params, (err, res, body) => 
			req.params.size ?= body.yeasts.length
			reply @render(
				body.yeasts, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.yeasts.length)
			)
		, req.token


module.exports = Handler


