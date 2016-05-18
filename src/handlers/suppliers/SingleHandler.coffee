###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/suppliers/{id}', method: 'GET' }

	render: (item, related = [], user) ->
		return @renderer.page
			title: "#{item.name} - suppliers - Ingredients"
			navigationState: 'other'
			user: user
			html: @renderer.render
				template: "public/templates/suppliers/index.jade"
				data:
					type: 'suppliers' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					related: related

	onRequest: (request, reply) ->
		@api.suppliers.get request.params, (err, res, body) =>
			@api.search.esSearch
				params:
					size: 100
					q: "type:(hop OR fermentable OR yeast) AND supplier.id:#{body.suppliers[0].supplierId}"
					sort: 'productCode:asc'
			, (err, res, esBody) =>
				console.log JSON.stringify esBody, false, '\t'
				reply @render(body.suppliers[0], esBody.hits.hits, request.user)
		, request.token


module.exports = SingleHandler
