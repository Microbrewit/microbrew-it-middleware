###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../core/RouteHandler'

class Handler extends RouteHandler

	validEndpoints: [
		'yeasts'
		'hops'
		'fermentables'
		'beerstyles'
		'others'

		'origins'
		'suppliers'
		# 'breweries'
		# 'users'
	]

	getRoute: () ->
		super @validEndpoints.map (type) ->
			{ path: "/#{type}", method: 'GET' }

	subNav: (params, user) ->
		unless user
			return null
		else
			return [
				{href: "add/#{params.itemType}", label: 'Add', activeState: 'edit'}
			]

	render: (results, user, pagination, params) ->
		return @renderer.page
			title: "#{params.itemType}"
			navigationState: params.itemType
			user: user
			html: @renderer.render
				template: "public/templates/#{params.itemType}/index.jade"
				data: 
					type: params.itemType 
					headline: @renderer.headline params.itemType
					mode: 'list'
					results: results
					subNavState: params.itemType
					subnav: @subNav(user)
					nextPage: pagination.next
					prevPage: pagination.prev

	onRequest: (req, reply) ->
		req.params.itemType = (req.raw.path.split('/'))[1]
		{itemType} = req.params

		singular = itemType.substr(0, itemType.length - 1)

		@api.search.esSearch
			params:
				size: if req.params.size then req.params.size else 100
				from: if req.params.from then req.params.from else 0
				q: "type:#{singular}"
				sort: 'name:asc'
		, (err, res, body) =>
			req.params.size ?= body.hits.hits.length
			reply @render(
				body.hits.hits,
				req.user,
				@makePrevNextLink(req.params, req.raw.url.pathname, body.hits.hits.length)
				req.params
			)
		, req.token


module.exports = Handler


