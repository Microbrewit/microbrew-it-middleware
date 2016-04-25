# Used if ENV VARs is not set
exports.environment = 'dev'
exports.prod =
	connection:
		port: 3000
		host: 'localhost'
	api: 'https://api.microbrew.it'
	authUrl: 'https://auth.microbrew.it'
	clientId: ''
	clientSecret: ''
exports.stage =
	connection:
		port: 3000
		host: 'localhost'
	api: 'https://api.microbrew.it'
	authUrl: 'https://auth.microbrew.it'
	clientId: ''
	clientSecret: ''
exports.dev =
	connection:
		port: 3000
		host: 'localhost'
	api: 'https://api.microbrew.it'
	authUrl: 'https://auth.microbrew.it'
	clientId: ''
	clientSecret: ''
