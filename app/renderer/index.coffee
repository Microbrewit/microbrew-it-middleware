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

exports.header = (navigationState) ->
	return @render
		template: 'public/header.jade'
		data:
			navigationState: navigationState

exports.footer = (options) ->
	return @render
		template: 'public/footer.jade'
		data: options

exports.error = (options) ->
	return @render
		template: 'public/header.jade'
		data: options

