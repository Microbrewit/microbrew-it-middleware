###
Handler for Fermentable GET calls

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/fermentables/{id}', method: 'GET' }

	subNav: (id, user) ->
		unless user
			return null
		else
			return [
				{href: "fermentables/#{id}/edit", label: 'Edit', activeState: 'edit'}
				{href: "fermentables/#{id}/delete", label: 'Delete', activeState: 'delete'}
			]

	render: (item, user) ->
		return @renderer.page
			title: "#{item.name} - Fermentables - Ingredients"
			navigationState: 'fermentables'
			user: user
			html: @renderer.render
				template: "public/templates/fermentables/index.jade"
				data: 
					type:'fermentables' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					subnav: @subNav(item.fermentableId, user)

	onRequest: (request, reply) ->
		@api.fermentables.get request.params, (err, res, body) => 
			reply @render(body.fermentables[0], request.user)
		, request.token


module.exports = SingleHandler
