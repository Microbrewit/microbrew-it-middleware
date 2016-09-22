###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/yeasts/{id}', method: 'GET' }

	subNav: (id, user) ->
		unless user
			return null
		else
			return [
				{href: "yeasts/#{id}/edit", label: 'Edit', activeState: 'edit'}
				{href: "yeasts/#{id}/delete", label: 'Delete', activeState: 'delete'}
			]

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - Yeasts - Ingredients"
			navigationState: 'yeasts'
			user: user
			html: @renderer.render
				template: "public/templates/yeasts/index.jade"
				data: 
					type:'yeasts' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					subnav: @subNav(item.yeastId, user)

	onRequest: (request, reply) ->
		@api.yeasts.get request.params, (err, res, body) => 
			reply @render(body.yeasts[0], request.user)
		, request.token


module.exports = SingleHandler
