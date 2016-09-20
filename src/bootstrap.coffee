###
Microbrew.it middleware bootstrap.

Sets up routes and injects dependencies.

@author Torstein Thune
@copyright 2015 Microbrew.it
###
args = require('minimist')(process.argv.slice(2))

getEnvVar = ->
	envVar = {}
	envVar.api = process.env.API_URL
	envVar.authUrl = process.env.AUTH_URL
	envVar.clientId = process.env.CLIENT_ID
	envVar.clientSecret = process.env.CLIENT_SECRET

	envVar.connection =
		port: process.env.PORT
		host: process.env.HOST

	return envVar

if args.environment
	config = (require '../config')[args.environment]
else
	config = getEnvVar()

# Initialise microbrewit-node API wrapper
api = (require 'microbrewit-node').init
	apiUrl: config.api
	authUrl: config.authUrl
	clientId: config.clientId
	clientSecret: config.clientSecret

# Initialise Logger
logger = require './core/Logger'

# Inject api into RouteHandler base class
RouteHandler = require './core/RouteHandler'
RouteHandler.prototype.api = api

handlers = [
	'./handlers/api/ApiHandler'
	'./handlers/frontpage/IndexHandler'
	'./handlers/assets/StaticHandler'

	# Search
	'./handlers/search/SearchHandler'
	
	# Users & Account
	'./handlers/users/LoginHandler'
	'./handlers/users/LogoutHandler'
	'./handlers/users/ListHandler'
	'./handlers/users/SingleHandler'
	'./handlers/users/SettingsHandler'

	# Breweries
	'./handlers/breweries/ListHandler'
	'./handlers/breweries/SingleHandler'

	# Beers and recipes
	'./handlers/beers/ListHandler'
	'./handlers/beers/SingleHandler'
	'./handlers/beers/RecipeHandler'
	'./handlers/beers/PostHandler'
	'./handlers/beers/ImportHandler'

	# Other data
	'./handlers/glasses/ListHandler'
	'./handlers/glasses/SingleHandler'
	
	'./handlers/beerstyles/ListHandler'
	'./handlers/beerstyles/SingleHandler'

	'./handlers/suppliers/ListHandler'
	'./handlers/suppliers/SingleHandler'

	'./handlers/origins/ListHandler'
	'./handlers/origins/SingleHandler'
	
	# Ingredients
	'./handlers/fermentables/ListHandler'
	'./handlers/fermentables/SingleHandler'

	'./handlers/others/ListHandler'
	'./handlers/others/SingleHandler'

	'./handlers/hops/ListHandler'
	'./handlers/hops/SingleHandler'
	'./handlers/hops/EditHandler'

	'./handlers/yeasts/ListHandler'
	'./handlers/yeasts/SingleHandler'

	'./handlers/DeleteHandler'
]

handlersInit = []
routes = []

# Initialise handlers and get routes
for handler in handlers
	handler = new (require handler)()
	route = handler.getRoute()

	# Handler handles a single route
	unless route.length
		routes.push route
	# Handler handles multiple routes
	else
		routes = routes.concat route

	handlersInit.push handler

# Initialise server
server = new (require 'hapi').Server()
server.connection config.connection

#Registers a plugin for hapi
server.register {register: require('hapi-auth-cookie')}, (err) ->
	logger.log err if err


#Sets the configuration for the session.
server.auth.strategy 'session','cookie',
	password: 'supersecretpassword'
	cookie: 'app-cookie'
	ttl: 24 * 60 * 60 * 1000
	redirectTo: '/login'
	appendNext: true
	isSecure: false

server.route routes

server.start () ->
	logger.log "Microbrew.it running on http://#{config.connection.host}:#{config.connection.port}"
	logger.log JSON.stringify config, false, '\t'
