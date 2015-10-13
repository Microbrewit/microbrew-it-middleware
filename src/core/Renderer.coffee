jade = require 'jade'
calc = require 'microbrewit-formulas'
country = require './Countries'

exports.render = (renderObj) ->
	if renderObj.template
		options = renderObj.data
		options ?= {}
		options.pretty = true
		options.compileDebug = true
		options.convert = calc.convert.convert
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
	return {
		headline: headline
		subheader: subheader
	}

exports.footer = (options) ->
	return @render
		template: 'public/footer.jade'
		data: options

exports.error = (options) ->
	return @render
		template: 'public/header.jade'
		data: options

