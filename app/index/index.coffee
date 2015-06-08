exports.getRoutes = () ->
	return [{
			method: 'GET',
			path:'/', 
			handler: handler
	}]

handler = (req, reply) =>
	console.log @
	console.log exports
	reply 'hello world'