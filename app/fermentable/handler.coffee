exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/fermentable' 
			handler: handler
		}
		{
			method: 'GET'
			path: '/fermentable/{id}'
			handler: handler2
		}
	]

handler = (req, reply) =>
	reply 'hello any fermentable'

handler2 = (req, reply) =>
	reply "hello fermentable #{req.params.id}"