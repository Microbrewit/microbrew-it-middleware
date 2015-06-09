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

exports.header = (navigationState, title) ->
	title ?= "Homebrewer's home"
	title += " - #{navigationState} - Microbrew.it"
	return @render
		template: 'public/header.jade'
		data:
			navigationState: navigationState
			title: title

exports.footer = (options) ->
	return @render
		template: 'public/footer.jade'
		data: options

exports.error = (options) ->
	return @render
		template: 'public/header.jade'
		data: options

