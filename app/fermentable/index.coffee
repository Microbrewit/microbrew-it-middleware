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
	console.log req.url.path
	@get req.url.path, (status, response) =>
		console.log 'hello?'
		html = @renderer.header navigationElement, "Fermentables"
		html += @renderer.render
			data: 
				results: response.fermentables
			template: "#{__dirname}/fermentables.jade"
		html += @renderer.footer()

		reply html

singleFermentableHandler = (req, reply) =>
	@get req.url.path, (status, response) =>

		html = @renderer.header navigationElement, "#{response.fermentables[0].name} - Fermentables"
		html += @renderer.render
			template: "#{__dirname}/singleFermentable.jade"
			data: 
				fermentable: response.fermentables[0] 
		html += @renderer.footer()

		reply html
