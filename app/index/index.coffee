exports.getRoutes = () ->
	return [{
			method: 'GET',
			path:'/', 
			handler: handler
	}]

handler = (req, reply) =>
	html = @renderer.header('home') 
	html += @renderer.render
		template: "#{__dirname}/home.jade"
	html += @renderer.footer()
	reply html