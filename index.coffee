settings = require './settings.coffee'
http = require 'http'
server = new (require 'hapi').Server()
argv = require('minimist')(process.argv)
argv.environment ?= 'dev'
console.log 'settings', settings[argv.environment].connection
server.connection settings[argv.environment].connection

modules =
	static: require './app/static'
	index: require './app/index'

	fermentable: require './app/fermentable'
	hop: require './app/hop'
	yeast: undefined
	others: undefined
	
	brewery: undefined
	user: undefined
	
	search: undefined
	account: require './app/account'
	supplier: undefined
	beer: require './app/beers'
	origin: undefined
	glass: undefined
	beerStyle: undefined

	recipe: undefined

	error: require './app/error'

utils =
	renderer: require './app/renderer'
	http: require './app/http'

injectHelpers = () ->
	for key, module of modules
		if module?
			module.settings = settings[argv.environment]
			module.get = utils.http.get
			module.renderer = utils.renderer
			module.post = utils.http.post
			module.put = utils.http.put
			module.delete = utils.http.delete

getRoutes = () ->
	availableRoutes = []
	for key,module of modules
		availableRoutes = availableRoutes.concat module.getRoutes() if module?.getRoutes?
	return availableRoutes

injectHelpers()

#Registers a plugin for hapi
server.register( register: require('hapi-auth-cookie'), (err) ->
	if err 
		cosole.log err 

)

#Sets the configuration for the session.
server.auth.strategy 'session','cookie',
	password: 'supersecretpassword'
	cookie: 'app-cookie'
	ttl: 24 * 60 * 60 * 1000
	redirectTo: 'login'
	isSecure: false

server.route getRoutes()
server.start () ->
	console.log "Microbrew.it running with #{argv.environment} settings on http://#{settings[argv.environment].connection.host}:#{settings[argv.environment].connection.port}"

