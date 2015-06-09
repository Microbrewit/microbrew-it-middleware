exports.getRoutes = () ->
	return [{
			method: 'GET',
			path:'/', 
			handler: handler
	}]

handler = (req, reply) =>
	html = @renderer.header('home') + "<div>Hey there!</div>" + @renderer.footer()
	reply html