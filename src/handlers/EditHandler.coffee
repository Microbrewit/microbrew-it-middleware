###
EDIT Handler

Simple handling for deleting items

@author Torstein Thune
@copyright 2016 Microbrew.it
###

RouteHandler = require '../core/RouteHandler'

class Handler extends RouteHandler

	validEndpoints: [
		'fermentables'
		'users'
		'beers'
		'yeasts'
		'hops'
		'others'
		'ingredients'
		'beerstyles'
		'beerStyles'
		'suppliers'
		'breweries'
	]

	specialParams: [
		'endpoint'
	]

	getRoute: () ->
		super [
			{ path: '/{itemType}/{id}/edit', method: 'POST', handler: @editHandler, auth: true }
			{ path: '/{itemType}/{id}/edit', method: 'GET', handler: @showEdit, auth: true }
		]

	showEdit: (request, reply) =>
		request.params.itemType = 'beerStyles' if request.params.itemType is 'beerstyles'
		{id, itemType} = request.params

		unless itemType in @validEndpoints
			reply {"statusCode": 404, "error": "Not Found"}
			return

		@api[itemType]?.get request.params, (err, res, body) => 
			item = body[itemType]?[0]
			reply @renderer.page
				title: "EDIT #{itemType} #{id}"
				user: @_getUser request
				html: @renderer.render
					template: "public/templates/edit.jade"
					data:
						headline: @renderer.headline "#{item.name}", "EDIT: #{itemType[0].toUpperCase()}#{itemType[1...itemType.length - 1]} with ID #{id}"
						item: item
						type: itemType
						id: id
		, @_getToken request

	editHandler: (request, reply) =>
		request.params.itemType = 'beerStyles' if request.params.itemType is 'beerstyles'
		{id, itemType} = request.params


		unless itemType in @validEndpoints
			reply {"statusCode": 404, "error": "Not Found"}
			return

		query =
			partial: id
			body: JSON.parse request.payload.item

		@api[itemType]?.put query, (err, res, body) =>
			@logger.log 'statusCode', res.statusCode
			@logger.log body
			if err
				reply err
			else
				reply.redirect "/#{itemType.toLowerCase()}/#{id}"
		, @_getToken request

module.exports = Handler