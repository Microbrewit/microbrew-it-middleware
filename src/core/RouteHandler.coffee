renderer = require './Renderer'
calc = require 'microbrewit-formulas'
logger = require './Logger'
userUtils = require './User'

###
BaseHandler for handling requests

@author Torstein Thune
@copyright 2015 Microbrew.it
###
class RouteHandler
	constructor: ->

	# Logger instance, use this instead of console.log (see core/Logger)
	logger: logger

	# Renderer utility functions (see core/Renderer)
	renderer: renderer

	# Microbrewit-formulas (see https://github.com/Microbrewit/microbrewit-formulas)
	calc: calc

	# User utilities (see core/User)
	userUtils: userUtils

	# Microbrewit-node, injected on bootstrap (see https://github.com/Microbrewit/microbrewit-node)
	api: undefined

	# Standard render function.
	# Should be implemented on a per Handler basis
	render: (err, req, body, user) ->
		return body

	# Generate HAPI route object
	# @param [Object/Array] route
	# @option route [string] path Request url to handle
	# @option route [string] method (optional) The request method (default: GET)
	# @option route [string] redirect (optional) redirect path if not authenticated (default: false)
	# @option route [Function] handler (optional) Handler function for path (default: @request, calls @onRequest, calls @on<Method>)
	# @return [Object] HAPI route config object
	# @private
	_generateRoute: (route) ->
		@logger.error('No path provided in route') unless route.path

		route.redirect ?= false
		route.method ?= 'GET'
		route.method = route.method.toUpperCase()

		route.handler ?= @request

		return {
			method: route.method
			path: route.path

			config: 
				handler: route.handler

				auth:
					mode: 'try'
					strategy: 'session'

				plugins: 
					'hapi-auth-cookie':
						redirectTo: route.redirect
		}

	# Returns the route handled by this instance of the Handler
	# @param [Object/Array] routes
	# @option routes [string] path Request url to handle
	# @option routes [string] method (optional) The request method (default: GET)
	# @option routes [string] redirect (optional) redirect path if not authenticated (default: false)
	# @option routes [Function] handler (optional) Handler function for path (default: @request, calls @onRequest, calls @on<Method>)
	# @return [Array] array of HAPI config objects
	getRoute: (routes) ->
		routeArray = []
		if routes.length
			for route in routes
				routeArray.push @_generateRoute(route)
		else
			routeArray.push @_generateRoute(routes)

		return routeArray

	# Called by HAPI
	# Gathers some convenience information into a request object, then calls onRequest
	# @param [Object] req The REQUEST object
	# @param [Function] reply HAPI reply function
	request: (req, reply) =>
		# Recreate the request object using util handlers
		request =
			raw: req
			reply: reply
			token: @_getToken(req)
			user: @_getUser(req)
			headers: @_getHeaders(req)
			params: @_getParams(req)

		unless @onRequest(request, reply)
			if request.raw.method is 'get'
				@onGet request, reply
			else if request.raw.method is 'post'
				@onPost request, reply
			else if request.raw.method is 'delete'
				@onDelete request, reply
			else if request.raw.method is 'put'
				@onPut request, reply
			else if request.raw.method is 'patch'
				@onPatch request, reply

	# Handle incoming HTTP requests
	# @param [Object] req
	# @option req [Object] raw The raw HAPI HTTP request object
	# @option req [Object/Bool] token The token object or false
	# @option req [Object/Bool] user The logged in user object or false
	# @option req [Object] header The HTTP headers from the request
	# @option req [Object] params Combination of url-params (e.g fermentables/{id} adds id) and GET params (e.g size = 50). (Examples combined results in object {id: something, size: 50})
	# @option req [Function] reply The HAPI reply function
	# @param [Function] reply The HAPI reply function
	onRequest: (req, reply) ->
		return false

	# Default GET handler
	# Called with same params as @onRequest
	onGet: (req, reply) ->
		@logger.warn "#{@constructor.name}.onGet not implemented (path: #{req.raw.path})"

	# Default POST handler
	# Called with same params as @onRequest
	onPost: (req, reply) ->
		@logger.warn "#{@constructor.name}.onPost not implemented (path: #{req.raw.path})"

	# Default DELETE handler
	# Called with same params as @onRequest
	onDelete: (req, reply) ->
		@logger.warn "#{@constructor.name}.onDelete not implemented (path: #{req.raw.path})"

	# Default PUT handler
	# Called with same params as @onRequest
	onPut: (req, reply) ->
		@logger.warn "#{@constructor.name}.onPut not implemented (path: #{req.raw.path})"

	# Default PATCH handler
	# Called with same params as @onRequest
	onPatch: (req, reply) ->
		@logger.warn "#{@constructor.name}.onPatch not implemented (path: #{req.raw.path})"

	# Get token from request object
	# @param [Object] req HAPI HTTP Request
	# @return [Object/Bool] Token object or false
	# @private
	_getToken: (req) ->
		token = req?.auth?.credentials?.token
		return token

	# Get User oject from request object
	# @param [Object] req The HAPI HTTP Request
	# @return [Object/Bool] User object or false
	# @private
	_getUser: (req) ->
		user = req?.auth?.credentials?.user
		return user

	# Get request headers
	# @param [Object] req The HAPI HTTP Request
	# @return [Object] HTTP headers
	_getHeaders: (req) ->
		return req.headers

	# Get payload/GET  parameters
	# @param [Object] req HAPI HTTP request object
	# @return [Object] params GET params concated with path params (e.g {id})
	# @private
	_getParams: (req) ->
		params = {}

		for key,val of req.params
			params[key] = val 
		for key,val of req.query
			params[key] = val
		console.info 'PARAMS:', params

		return params

	# Convenience method for generating prev and next links for list results
	# @param [Object] query The API query
	# @param [Object] pathname The current path
	# @param [Array] currentResults The results of the API query
	# @return [Object] two urls: prev and next
	makePrevNextLink: (query, pathname, currentResults) ->
		query = JSON.parse JSON.stringify query

		query.size ?= 50
		query.from ?= 0

		next = JSON.parse JSON.stringify query # clone
		next.from = parseInt(query.from, 10) + parseInt(query.size,10)

		nextLink = pathname + '?'
		for key, val of next
			nextLink += "#{key}=#{val}&"



		prev = JSON.parse JSON.stringify query
		prev.from = parseInt(query.from, 10) - parseInt(query.size,10)

		if prev.from >= 0 and query.size <= currentResults
			prevLink = pathname + '?'
			for key, val of prev
				prevLink += "#{key}=#{val}&"
		else
			prevLink = undefined

		return {
			next: nextLink
			prev: prevLink
		}

module.exports = RouteHandler