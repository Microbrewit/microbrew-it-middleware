###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/others', method: 'GET' }

	render: (results, user, pagination) ->
		return @renderer.page
			title: "Other Ingredients - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/others/index.jade"
				data: 
					type:'others' 
					headline: @renderer.headline 'Others', 'Fruits, berries, unfermentable sugars, spices'
					mode: 'list'
					results: results
					subNavState: 'others'
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
		@api.others.get req.params, (err, res, body) => 
			req.params.size ?= body.others.length
			reply @render(
				body.others, 
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.others.length)
			)
		, req.token


module.exports = Handler


