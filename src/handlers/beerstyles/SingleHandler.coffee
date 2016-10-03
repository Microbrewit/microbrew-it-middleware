###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super [
			{ path: '/beerstyles/{id}', method: 'GET' }
			{ path: '/beerStyles/{id}', method: 'GET' }
		]

	subNav: (params, user) ->
		console.log 'subNav', params
		unless user
			return null
		else
			return [
				{href: "beerstyles/#{params.id}/edit", label: 'Edit', activeState: 'edit'}
				{href: "beerstyles/#{params.id}/delete", label: 'Delete', activeState: 'delete'}
			]

	render: (item, user, params) ->
		console.log 'render', params
		return @renderer.page
			title: "#{item.name} - beerstyles"
			navigationState: 'beerstyles'
			user: user
			html: @renderer.render
				template: "public/templates/beerstyles/index.jade"
				data: 
					type:'beerstyles' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					subnav: @subNav(params, user)

	onRequest: (request, reply) ->
		id = request.params?.id
		console.log 'onRequest', request.params

		@api.beerStyles.get request.params, (err, res, body) => 
			console.log 'api response', id
			reply @render(body.beerStyles[0], request.user, {id})
		, request.token


module.exports = SingleHandler
