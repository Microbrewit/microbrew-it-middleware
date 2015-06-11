http = require 'http'

exports.get = (url, onSuccess, onError) ->
	request = http.get("#{@settings.api}#{url}", (res) ->
		response = ''
		# We receive data in chunks
		res.on 'data', (chunk) ->
			response+=chunk

		# Request ended, write file (if we have any data)
		res.on 'end', () ->
			if response isnt ''
				try
					response = JSON.parse response
				catch e 
					console.log e
				onSuccess?(200, response)
	, (err) ->
		onError?(err)
	)
exports.post = () ->

exports.put = () ->

exports.delete = () ->