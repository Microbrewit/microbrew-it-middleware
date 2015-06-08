settings = require './settings.coffee'
server = new (require 'hapi').Server()
argv = require('minimist')(process.argv)
argv.environment ?= 'dev'
console.log 'settings', settings[argv.environment].connection
server.connection settings[argv.environment].connection

modules =
	index: require './app/index/handler.coffee'
	# Ingredients
	fermentable: require './app/fermentable/handler.coffee'
	hop: undefined
	yeast: undefined
	others: undefined
	
	brewery: undefined
	user: undefined
	
	search: undefined
	account: undefined
	supplier: undefined
	beer: undefined
	origin: undefined
	glass: undefined
	beerStyle: undefined

	recipe: undefined


availableRoutes = []

for key,module of modules
	if module?.getRoutes?
		routes = module.getRoutes()
		availableRoutes = availableRoutes.concat routes

console.log availableRoutes

server.route availableRoutes
server.start () ->
	console.log "Microbrew.it running with #{argv.environment} settings on http://#{settings[argv.environment].connection.host}:#{settings[argv.environment].connection.port}"

