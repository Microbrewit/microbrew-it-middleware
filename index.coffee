settings = require './settings.coffee'
http = require 'http'
server = new (require 'hapi').Server()
argv = require('minimist')(process.argv)
argv.environment ?= 'dev'
console.log 'settings', settings[argv.environment].connection
server.connection settings[argv.environment].connection

# sass = require 'node-sass'
# fs = require 'fs'
# sassRes = sass.renderSync
# 	file: 'public/scss/main.scss'
# 	outputStyle: 'compressed'
# 	outFile: 'public/css/main.css'
# 	sourceMap: false

# fs.writeFile 'public/css/main.css', sassRes.css, () ->
# 	console.log 'done'

modules =
	static: require './app/static'
	index: require './app/index'

	fermentable: require './app/fermentable'
	hop: require './app/hop'
	yeast: require './app/yeasts'
	others: require './app/others'
	ingredients: require './app/ingredients'
	
	brewery: require './app/breweries'
	user: require './app/users'
	
	search: require './app/search'
	account: require './app/account'
	supplier: require './app/suppliers'
	beer: require './app/beers'
	origin: require './app/origins'
	glass: require './app/glasses'
	beerStyle: require './app/beerstyles'
	randomize: require './app/randomize'

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

# Handle all server errors with the default error page
# @todo more granular error handling
server.ext 'onPreResponse', (request, reply) ->
	if request.response.isBoom
		err = request.response
		errName = err.output.payload.error
		message = err.output.payload.message or= ''
		statusCode = err.output.payload.statusCode
		if err.isDeveloperError then ourFault = 'This is probably our fault.' else ourFault = ''

		reply utils.renderer.page
			title: "#{statusCode} #{errName}"
			html: utils.renderer.render
				template: "public/templates/error.jade"
				data:
					headline: 
						headline: "HTTP #{statusCode} =("
						subheader: "#{errName}"
					error: "<p class=\"center\">#{message}<br /> #{ourFault}</p>"
	else
    	reply.continue()

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

