###
EDIT Handler

Simple handling for deleting items

@author Torstein Thune
@copyright 2016 Microbrew.it
###

RouteHandler = require '../core/RouteHandler'

class Handler extends RouteHandler

	jsonTemplates:
		fermentables: {}
		hops: {}
		yeasts: {}

	getTemplate: (type) ->
		return if @jsonTemplates[type] then @jsonTemplates[type] else {}


	getRoute: () ->
		super [
			{ path: '/add/{itemType}', method: 'POST', handler: @addHandler, auth: true }
			{ path: '/add/{itemType}', method: 'GET', handler: @showAdd, auth: true }
		]

	showAdd: (request, reply) =>
		{itemType} = request.params
		
		reply @renderer.page
			title: "ADD #{itemType}"
			user: request.user
			html: @renderer.render
				template: "public/templates/edit.jade"
				data:
					headline: @renderer.headline "ADD #{itemType[0].toUpperCase()}#{itemType[1...itemType.length - 1]}"
					item: @getTemplate(itemType)
					type: itemType

	addHandler: (request, reply) =>
		{itemType} = request.params

		query =
			body: JSON.parse request.payload.item

		@api[itemType]?.post query, (err, res, body) =>
			
			if err
				reply err
			else
				reply body
				# reply.redirect "/#{itemType}/#{id}"
		, @_getToken request

module.exports = Handler