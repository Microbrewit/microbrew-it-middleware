###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super { path: '/origins/{id}', method: 'GET' }

	render: (item, results, user) ->
		return @renderer.page
			title: "#{item.name} - origins - Ingredients"
			navigationState: 'other'
			user: user
			html: @renderer.render
				template: "public/templates/origins/index.jade"
				data: 
					type:'origins' 
					headline: @renderer.headline "#{item.name}", "#{item.type}"
					mode: 'single'
					item: item
					results: results

	onRequest: (request, reply) ->
		console.log request.params
		@api.origins.get request.params, (err, res, body) => 
			@api.search.esSearch
				params:
					size: 100
					q: "type:(hop OR fermentable OR yeast) AND origin.id:#{body.origins[0].originId}"
					sort: 'name:asc'
			, (err, res, results) =>
				reply @render(body.origins[0], results.hits.hits, request.user)
		, request.token


module.exports = SingleHandler
