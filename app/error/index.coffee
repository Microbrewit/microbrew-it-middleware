exports.getRoutes = () ->
	return [
		{
			method: '*',
			path: '/{p*}', # catch-all path
			handler:  (request, reply) ->
				reply '404 not found'
			
		}
	]