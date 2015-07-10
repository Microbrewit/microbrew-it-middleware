avatar = require('avatar-generator')()
fs = require 'fs'
path = require 'path'
crypto = require 'crypto'

tempPath = path.join(process.cwd(), 'public/images/avatars')

exports.getRoutes = () ->
	return [
		{
			method: 'GET'
			path:'/random/{filename}' 
			config: 
				handler: handler

						
				auth: 
					mode: 'try',
					strategy: 'session'
			
				plugins: 
					'hapi-auth-cookie': 
						redirectTo: false  
		}
	]

handler = (req, reply) =>
	filename = req.params.filename
	size = req.query.size 
	size ?= 80
	etag = crypto.createHash('md5').update(filename+size).digest('hex')

	fpath = path.join(tempPath,etag+'.png')
	fs.exists(fpath, (exists) ->
		if exists
			reply.file(fpath)
		else
			# Generate new one
			image = avatar(filename, 'male', size).stream()
			image.pipe(fs.createWriteStream(fpath))
			image.on 'unpipe', (src) ->
				reply.file(fpath)
	)