exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/fermentables' 
			handler: handler
		}
		{
			method: 'GET'
			path: '/fermentables/{id}'
			handler: singleFermentableHandler
		}
	]

handler = (req, reply) =>
	reply 'hello any fermentable'

singleFermentableHandler = (req, reply) =>
	@get(req.url.path, (status, response) =>
		@render(response, './singleFermentable', (html) -> reply html)
	)
