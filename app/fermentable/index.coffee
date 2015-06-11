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
	@get req.url.path, (status, response) =>
		reply @renderer.page
			head: @renderer.head 'Fermentables - Ingredients'
			navigation: @renderer.navigation 'ingredients'
			headline: @renderer.headline 'Fermentables', 'Malts, adjuncts, sugars'
			html: @renderer.render
				template: "#{__dirname}/fermentables.jade"
				data: 
					results: response.fermentables

singleFermentableHandler = (req, reply) =>
	@get req.url.path, (status, response) =>
		reply @renderer.page
			head: @renderer.head "#{response.fermentables[0].name} - Fermentables - Ingredients"
			navigation: @renderer.navigation 'ingredients'
			headline: @renderer.headline "#{response.fermentables[0].name}", "#{response.fermentables[0].type}"
			html: @renderer.render
				template: "#{__dirname}/fermentables.single.jade"
				data: response.fermentables[0]

