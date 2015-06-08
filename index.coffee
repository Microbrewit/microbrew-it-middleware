settings = require './settings.coffee'
http = require 'http'
server = new (require 'hapi').Server()
argv = require('minimist')(process.argv)
argv.environment ?= 'dev'
console.log 'settings', settings[argv.environment].connection
server.connection settings[argv.environment].connection

modules =
	index: require './app/index'

	fermentable: require './app/fermentable'
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

injectHelpers = () ->
	for key, module of modules
		if module?
			module.settings = settings[argv.environment]
			module.render = (data, template, reply) ->
				reply data
			module.get = (url, onSuccess, onError) ->
				request = http.get("#{@settings.api}#{url}", (res) ->
					response = ''
					# We receive data in chunks
					res.on 'data', (chunk) ->
						response+=chunk

					# Request ended, write file (if we have any data)
					res.on 'end', () ->
						if response isnt ''
							try
								response = JSON.parse response
							catch e 
								console.log e
							onSuccess?(200, response)
				, (err) ->
					onError?(err)
				)

			module.post = () ->
			module.put = () ->
			module.delete = () ->

getRoutes = () ->
	availableRoutes = []
	for key,module of modules
		availableRoutes = availableRoutes.concat module.getRoutes() if module?.getRoutes?
	return availableRoutes

injectHelpers()

server.route getRoutes()
server.start () ->
	console.log "Microbrew.it running with #{argv.environment} settings on http://#{settings[argv.environment].connection.host}:#{settings[argv.environment].connection.port}"

