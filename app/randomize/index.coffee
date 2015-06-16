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

# var app = connect()
# 	.use(function (req, res) {
# 		try {
# 			//parse url and generate avatar on the fly
# 			var query = url.parse(req.url, true).query;
# 			if (query && query.id && avatar.discriminators.indexOf(query.s) !== -1) {
# 				var size = parseInt(query.size) || 400;
# 				var etag = crypto.createHash('md5').update(query.id + query.s + size).digest('hex');
# 				if (req.headers['if-none-match'] === etag) {
# 					res.writeHead(304);
# 					res.end();
# 				} else {
# 					res.writeHead(200, {
# 						'Content-Type': 'image/png',
# 						'ETag':etag
# 					});
# 					var fpath = path.join(tempPath,etag+'.png');
# 					//Check for file exists in temp
# 					fs.exists(fpath, function (exists) {
# 						if (exists){
# 							//Stream to resp
# 							fs.createReadStream(fpath).pipe(res);
# 						} else {
# 							//Generate new one
# 							var image =avatar(query.id, query.s, size).stream();
# 							image.pipe(fs.createWriteStream(fpath));
# 							image.pipe(res);
# 						}
# 					});
# 				}
# 			} else {
# 				res.writeHead(400);
# 				res.end();
# 			}
# 		} catch (err) {
# 			res.writeHead(500);
# 			res.end();
# 		}
# 	});

# http.createServer(app).listen(process.env.PORT || 3000);