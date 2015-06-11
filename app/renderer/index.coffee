fs = require 'fs'
jade = require 'jade'

exports.render = (renderObj) ->
	if renderObj.template
		options = renderObj.data
		options ?= {}
		options.pretty = true
		options.compileDebug = true
		return jade.renderFile(renderObj.template, options)
	else
		return renderObj.data

exports.page = (data) ->
	return @render
		template: 'public/index.jade'
		data: data

exports.head = (title) ->
	title ?= "Homebrewer's home"
	title += " - Microbrew.it"
	return @render
		template: 'public/head.jade'
		data:
			title: title

exports.navigation = (navigationState) ->
	return @render
		template: 'public/navigation.jade'
		data:
			navigationState: navigationState

exports.headline = (headline, subheader, image = "") ->
	return @render
		template: 'public/headline.jade'
		data:
			headline: headline
			subheader: subheader
			image: image

exports.footer = (options) ->
	return @render
		template: 'public/footer.jade'
		data: options

exports.error = (options) ->
	return @render
		template: 'public/header.jade'
		data: options

