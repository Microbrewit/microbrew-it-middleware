http = require 'http'
request = require('request');


exports.get = (url, onSuccess, onError) ->
	try
		req = http.get("#{@settings.api}#{url}", (res) ->
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
	catch e
		console.log 'catch'
		onError(e)
#Takes a query that is posted to the api
#@param [Object] query, the query contining, url, body, headers.
exports.post = (query, onSuccess, onError) ->
	console.log 'POST'
	console.log "POST: #{@settings.api}/#{query.url}"
	request.post(
		headers: query.headers
		url: "#{@settings.api}#{query.url}"
		body: query.body
	, (error, response, body) ->
		console.log body
		console.log response
		if(error)
  			onError?(error)	
		onSuccess?(response.statusCode, JSON.parse(body))
	)

#Takes a query that is put to the api
#@param [Object] query, the query contining, url, body, headers.
exports.put = (query, onSuccess, onError) ->
	request.put(
		headers: query.headers
		url: "#{@settings.api}#{query.url}"
		body: query.body
	,(error, response, body) ->
		if(error)
			onError?(error)
		onSuccess?(response.statusCode, body)
	)
#Takes a query that is delete to the api
#@param [Object] query, the query contining, url, headers.
exports.delete = (query, onSuccess, onError) ->
	console.log "#{@settings.api}#{query.url}"
	request.del(
		headers: query.headers
		url: "#{@settings.api}#{query.url}"
	,(error, response, body) ->
		if(error)
  			onError?(error)	
		console.log response.statusCode
		onSuccess?(response.statusCode, JSON.parse body)				
	)