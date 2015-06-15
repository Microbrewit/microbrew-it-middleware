fs = require 'fs'
jade = require 'jade'
conversion = require '../utils/convert.coffee'
country = require '../utils/countries.coffee'

exports.render = (renderObj) ->
	console.log 'renderer.render'
	console.log @user
	if renderObj.template
		options = renderObj.data
		options ?= {}
		options.user = @user
		options.pretty = true
		options.compileDebug = true
		options.convert = conversion.convert
		options.country = country
		return jade.renderFile(renderObj.template, options)
	else
		return renderObj.data

exports.page = (data) ->
	return @render
		template: 'public/index.jade'
		data: data

exports.header = (title) ->
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

