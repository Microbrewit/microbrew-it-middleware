exports.getRoutes = () ->
	return [
		# {
		# 	method: '*',
		# 	path: '/{p*}', # catch-all path
		# 	handler:  (request, reply) =>
		# 		reply @renderer.page
		# 			title: '404 Page not found'
		# 			html: @renderer.render
		# 				template: "public/templates/error.jade"
		# 				data:
		# 					headline: 
		# 						headline: 'HTTP 404 =('
		# 						subheader: 'Page not found'
		# 					error: "Sorry 'bout that"
			
		# }
		# {
		# 	method: '*'
		# 	path: '/failure'
		# 	handler: (req) ->
		# 		req.reply(new Error('Returned'))
		# }
		# {
		# 	method: '*'
		# 	path: '/throws'
		# 	handler: (req) ->
		# 		throw new Error 'Thrown'
		# }
	]