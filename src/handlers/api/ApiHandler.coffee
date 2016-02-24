###
API wrapper

Some times frontend applications want to get data from the API without thinking about CORS.

@author Torstein Thune
@copyright 2016 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class Handler extends RouteHandler

	validEndpoints: [
		'fermentables'
		'users'
		'beers'
		'yeasts'
		'hops'
		'others'
	]

	specialParams: [
		'endpoint'
	]

	getRoute: () ->
		super [
			{ 
				path: '/json'
				method: 'POST'
			}
			{ 
				path: '/json/*'
				method: 'PUT'
			}
			{ 
				path: '/json/{endpoint}'
				method: 'GET'
			}
			{ 
				path: '/json/{endpoint}/{id}'
				method: 'GET'
			}
			{ 
				path: '/json'
				method: 'DELETE'
			}
		]

	checkEndpoint: (endpoint) ->
		return endpoint in @validEndpoints

	findApiParams: (params) ->
		
		apiParams = {}

		for key, val of params
			unless key in @specialParams
				apiParams[key] = val

		return apiParams

	replyInvalid: (reply) ->
		reply JSON.stringify {"error": "invalid request"}

	replyApiError: (err, res, body, reply) ->
		if res.statusCode >= 500 and res.statusCode < 600
			reply JSON.stringify {statusCode: 500, error: body}
		else 
			reply body

	onGet: (req, reply) ->
		if @checkEndpoint req.params.endpoint
			@api[req.params.endpoint].get @findApiParams(req.params), (err, res, body) =>
				if res.statusCode is 500
					@replyApiError err, res, body, reply
				else
					reply body
		else
			@replyInvalid reply

	onPut: (req, reply) ->
		if @checkEndpoint req.params.endpoint and req.token
			@api[req.params.endpoint].put @findApiParams(req.params), (err, res, body) =>
				if res.statusCode is 500
					@replyApiError err, res, body, reply
				else
					reply body
			, req.token
		else
			@replyInvalid reply

	onDelete: (req, reply) ->
		if @checkEndpoint req.params.endpoint and req.token
			@api[req.params.endpoint].delete @findApiParams(req.params), (err, res, body) =>
				if res.statusCode is 500
					@replyApiError err, res, body, reply
				else
					reply body
			, req.token
		else
			@replyInvalid reply

	onPost: (req, reply) ->
		if @checkEndpoint req.params.endpoint and req.token
			@api[req.params.endpoint].post @findApiParams(req.params), (err, res, body) =>
				if res.statusCode is 500
					@replyApiError err, res, body, reply
				else
					reply body
			, req.token
		else
			@replyInvalid reply


module.exports = Handler


