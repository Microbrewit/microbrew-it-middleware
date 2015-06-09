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

navigationElement = 'ingredients'

handler = (req, reply) =>
	@get req.url.path, (status, response) =>
		@render
			req: req 
			reply: reply
			data: response
			template: undefined

singleFermentableHandler = (req, reply) =>
	@get req.url.path, (status, response) =>

		html = @renderer.header navigationElement
		html += @renderer.render
			template: "#{__dirname}/singleFermentable.jade"
			data: 
				fermentable: response.fermentables[0] 
		html += @renderer.footer()

		reply html
