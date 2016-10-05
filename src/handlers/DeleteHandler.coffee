###
DELETE Handler

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
		'beerStyles'
		'suppliers'
		'breweries'
	]

	specialParams: [
		'endpoint'
	]

	getRoute: () ->
		super [
			{ path: '/{itemType}/{id}/delete', method: 'POST', handler: @deleteHandler, auth: true }
			{ path: '/{itemType}/{id}/delete', method: 'GET', handler: @showDelete, auth: true }
		]

	showDelete: (request, reply) =>
		{id, itemType} = request.params

		unless itemType in @validEndpoints
			reply {"statusCode": 404, "error": "Not Found"}
			return

		@api[itemType]?.get request.params, (err, res, body) => 
			item = body[itemType]?[0]
			reply @renderer.page
				title: "DELETE #{item.name} (#{id})"
				user: request.user
				html: @renderer.render
					template: "public/templates/delete.jade"
					data:
						headline: @renderer.headline "DELETE #{item.name}", " #{itemType[0].toUpperCase()}#{itemType[1...itemType.length - 1]} with ID #{id}"
						item: item
						type: itemType
						id: id

	deleteHandler: (request, reply) =>
		{id, itemType} = request.params

		unless itemType in @validEndpoints
			reply {"statusCode": 404, "error": "Not Found"}
			return

		if @api[itemType]?
			@api[itemType].delete {id}, (err, res, body) =>
				if err
					reply err
				else
					reply.redirect "/#{itemType}"

			, @_getToken request

module.exports = Handler