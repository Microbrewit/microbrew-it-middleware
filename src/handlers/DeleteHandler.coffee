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
	]

	specialParams: [
		'endpoint'
	]

	getRoute: () ->
		super [
			{ path: '/{itemType}/{id}/delete', method: 'POST', handler: @deleteHandler }
			{ path: '/{itemType}/{id}/delete', method: 'GET', handler: @showDelete }
		]

	showDelete: (request, reply) =>
		reply @renderer.page
			title: "DELETE"
			user: request.user
			html: @renderer.render
				template: "public/templates/delete.jade"
				data:
					type: request.params.itemType
					id: request.params.id
					mode: 'delete'

	deleteHandler: (request, reply) =>
		console.log 'deleteHandler'

		{id, itemType} = request.params

		if @api[itemType]?
			console.log 'ait'
			@api[itemType].delete id, (err, res, body) =>
				if err
					reply err
				else
					reply body
			, request.token

module.exports = Handler