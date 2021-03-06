###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	replaceLast: (string, find, replace) ->
		index = string.lastIndexOf(find)

		if index >= 0
			return string.substring(0, index) + replace + string.substring(index + find.length)

		return string

	getRoute: () ->
		super { path: '/hops/{id}', method: 'GET' }

	subNav: (id, user) ->
		unless user
			return null
		else
			return [
				{href: "hops/#{id}/edit", label: 'Edit', activeState: 'edit'}
				{href: "hops/#{id}/delete", label: 'Delete', activeState: 'delete'}
			]

	render: (item, user) ->

		beerStylesPretty = []

		if item.beerstyles
			for style in item.beerstyles
				beerStylesPretty.push "<a href=\"beerstyles/#{style.id}\">#{style.name.trim()}</a>"

		beerStylesPretty = @replaceLast(beerStylesPretty.join(', '), ', ', ' and ')


		return @renderer.page
			title: "#{item.name} - Hops - Ingredients"
			navigationState: 'hops'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					type:'hops' 
					headline: @renderer.headline "#{item.name}", "#{item.purpose} Hop"
					mode: 'single'
					item: item
					beerStylesPretty: beerStylesPretty
					subnav: @subNav(item.hopId, user)

	onRequest: (request, reply) ->
		@api.hops.get request.params, (err, res, body) => 
			reply @render(body.hops[0], request.user)
		, request.token


module.exports = SingleHandler
