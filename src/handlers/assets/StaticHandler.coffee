###
Handles requests for static assets (images, css, etc.)

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class StaticHandler extends RouteHandler

	getRoute: () ->
		return [
			{
				method: 'GET',
				path:'/css/{filename}', 
				handler: 
					file: (request) ->
						return "public/css/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/js/{filename}', 
				handler: 
					file: (request) ->
						return "public/js/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/images/{filename}', 
				handler: 
					file: (request) ->
						return "public/images/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/images/flags/{filename}', 
				handler: 
					file: (request) ->
						return "public/images/flags/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/fonts/{filename}', 
				handler: 
					file: (request) ->
						return "public/fonts/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/recipe/{p*}', 
				handler: 
					file: (request) ->
						return "public/recipe/#{request.params.p}"
			}
			# {
			# 	method: 'GET',
			# 	path:'/recipe/build/{filename}', 
			# 	handler: 
			# 		file: (request) ->
			# 			return "public/recipe/build/#{request.params.filename}"
			# }
			{
				method: 'GET',
				path:'/templates/beers/{filename}', 
				handler: 
					file: (request) ->
						console.log "Request for #{request.params.filename}"
						console.log "return public/templates/beers/#{request.params.filename}"
						return "public/templates/beers/#{request.params.filename}"
			}
			{
				method: 'GET',
				path:'/templates/recipe/{filename}', 
				handler: 
					file: (request) ->
						console.log "Request for #{request.params.filename}"
						console.log "return public/templates/beers/#{request.params.filename}"
						return "public/templates/beers/#{request.params.filename}"
			}
		]

module.exports = StaticHandler


