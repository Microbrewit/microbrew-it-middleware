###

@author Torstein Thune
@copyright 2015 Microbrew.it
###

RouteHandler = require '../../core/RouteHandler'

class SingleHandler extends RouteHandler

	getRoute: () ->
		super {path: '/users/{id}', method: 'GET'}

	render: (item, user) ->
		return @renderer.page
			title: "#{item.username} - users"
			navigationState: 'users'
			user: user
			html: @renderer.render
				template: 'public/templates/users/index.jade'
				data:
					type: 'users'
					headline: @renderer.headline "#{item.username}", "#{item.type}"
					mode: 'single'
					item: item

	renderLoggedUser: (item, user) ->
		return @renderer.page
			title: "#{item.username} - users"
			navigationState: 'account'
			user: user
			html: @renderer.render
				template: 'public/templates/users/index.jade'
				data:
					type:'users'
					headline: @renderer.headline "#{item.username}", 'This is you'
					subNavState: 'beers'
					subnav: [
						{href: '/beers/add', label: 'Add recipe', activeState: 'recipes'}
						{href: "/users/#{user.username}/beers", label: 'My Beers', activeState: 'beers'}
						#{href: "/users/#{user.username}/breweries", label: 'My Breweries', activeState: 'breweries'}
						{href: "/users/#{user.username}/settings", label: 'Settings', activeState: 'settings'}
						{href: '/logout', label: 'Logout', activeState: 'logout'}

					]
					mode: 'single'
					item: item

	onRequest: (request, reply) ->
		@api.users.get request.params, (err, res, body) =>
			if request.params.id is body.users[0].username
				reply @renderLoggedUser(body.users[0], request.user)
			else
				reply @render(body.users[0], request.user)
		, request.token


module.exports = SingleHandler
