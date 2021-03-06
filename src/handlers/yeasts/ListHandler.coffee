###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	getRoute: () ->
		super { path: '/yeasts', method: 'GET' }

	subNav: (user) ->
		unless user
			return null
		else
			return [
				{href: 'add/yeasts', label: 'Add'}
			]

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
					subnav: @subNav(user)
					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		@api.search.esSearch
			params:
				size: if req.params.size then req.params.size else 100
				from: if req.params.from then req.params.from else 0
				q: 'type:yeast'
				sort: 'name:asc'
		, (err, res, body) =>
			req.params.size ?= body.hits.hits.length
			reply @render(
				body.hits.hits,
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.hits.hits.length)
			)
		, req.token


module.exports = Handler


