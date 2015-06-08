# microbrew-it-middleware
Microbrew-it-middleware is the Node.js middleware for Microbrew.it that handles the web frontend. It's job is to query the API and render templates/deliver SPAs for specific tasks like recipes.

Start server: ```coffee index.coffee --environment (dev/stage/prod default: dev)```

## Dependencies
You need Node.js installed.
- Node.js (use brew/apt-get/nodejs.org)
- Coffeescript: ```npm install -g coffee-script```
- Local dependencies: ```npm install```

## Adding a module
Create a folder in /app.
Create a handler.coffee file.

In the handler.coffee-file create and export a getRoutes method returning the routes that the handler can handle.

Create render/handle methods for each route.

Add the handler to modules in index.coffee.

See /app/index.coffee for an example handler.
