exports.getRoutes = () ->
	return [{
			method: 'GET',
			path:'/', 
			handler: handler
	}]

handler = (req, reply) =>
	reply 'hello world'