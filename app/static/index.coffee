exports.getRoutes = () ->
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
	]