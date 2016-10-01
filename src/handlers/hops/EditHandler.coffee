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
		super [
			{ path: '/hops/add', method: 'GET', handler: @addHandler }
			{ path: '/hops/add', method: 'POST', handler: @addHandler }
			{ path: '/hops/{id}/edit', method: 'GET', handler: @editHandler }
			{ path: '/hops/{id}/edit', method: 'POST', handler: @editHandler }
		]


	editHandler: (request, reply) =>

		@api.hops.aromas {}, (err, res, aromas) =>
			@api.hops.get request.params, (err, res, body) => 
				@logger.log 'body', body
				reply @render(body.hops[0], request.user, aromas)
			, request.token
		, request.token

	render: (item, user, aromas) ->

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
					type: 'hops' 
					headline: @renderer.headline "#{item.name}", "#{item.purpose} Hop"
					mode: 'edit'
					item: item
					aromas: aromas
					beerStylesPretty: beerStylesPretty

	onRequest: (request, reply) ->
		@api.hops.aromas {}, (err, res, body) =>
			@api.hops.get request.params, (err, res, body) => 
				reply @render(body.hops[0], request.user)
			, request.token
		, request.token


module.exports = SingleHandler
