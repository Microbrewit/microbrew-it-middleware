###

@author Torstein Thune
@copyright 2016 Microbrew.it
###

RouteHandler = require '../core/RouteHandler'

class SingleHandler extends RouteHandler

	validEndpoints: [
		'yeasts'
		'hops'
		'fermentables'
		'glasses'
		# 'beerstyles'
		'others'
	]

	getRoute: () ->
		super @validEndpoints.map (type) ->
			{ path: "/#{type}/{id}", method: 'GET' }

	subNav: (params, user) ->
		unless user
			return null
		else
			return [
				{href: "#{params.itemType}/#{params.id}/edit", label: 'Edit', activeState: 'edit'}
				{href: "#{params.itemType}/#{params.id}/delete", label: 'Delete', activeState: 'delete'}
			]

	render: (item, user, params) ->
		return @renderer.page
			title: "#{item.name} - #{params.itemType}"
			navigationState: params.itemType
			user: user
			html: @renderer.render
				template: "public/templates/#{params.itemType}/index.jade"
				data: 
					type: params.itemType
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					subnav: @subNav(params, user)

	onRequest: (request, reply) ->
		request.params.itemType = (request.raw.path.split('/'))[1]
		request.params.itemType = 'beerStyles' if request.params.itemType is 'beerstyles'

		{id, itemType} = request.params

		@api[itemType].get {id}, (err, res, body) => 
			reply @render(body[itemType][0], request.user, request.params)
		, request.token


module.exports = SingleHandler
