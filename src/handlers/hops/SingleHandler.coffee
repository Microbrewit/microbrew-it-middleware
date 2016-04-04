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

	render: (item, user) ->

		beerStylesPretty = []
		for style in item.beerStyles
			beerStylesPretty.push "<a href=\"beerstyles/#{style.id}\">#{style.name.trim()}</a>"

		beerStylesPretty = @replaceLast(beerStylesPretty.join(', '), ', ', ' and ')


		return @renderer.page
			title: "#{item.name} - Hops - Ingredients"
			navigationState: 'ingredients'
			user: user
			html: @renderer.render
				template: "public/templates/hops/index.jade"
				data: 
					type:'hops' 
					headline: @renderer.headline "#{item.name}", "#{item.purpose} Hop"
					mode: 'single'
					item: item
					beerStylesPretty: beerStylesPretty

	onRequest: (request, reply) ->
		@api.hops.get request.params, (err, res, body) => 
			reply @render(body.hops[0], request.user)
		, request.token


module.exports = SingleHandler
