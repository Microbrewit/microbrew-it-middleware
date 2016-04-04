# Microbrew.it Middleware
The middleware takes care of rendering and serving the frontend on http://microbrew.it.

## Installation and requirements
microbrew-it-middleware requires Node.js to run.

### Development
Installing requirements: `npm install -g forever nodemon && npm install`.

NOTE: You will need to install GNU Parallels to run the `npm run watch-dev` task (see below). On OS X with Homebrew installed this is as simple as running `brew install parallels`.

Available npm scripts:
- `npm start` Run with production settings (+ forever as daemon)
- `npm run dev` Run with development settings (+ nodemon as daemon)
- `npm run build-css` Uses node-sass to compile scss.
- `npm run watch-css` Uses nodemon + node-sass to compile scss on the fly.
- `npm run watch-dev` Uses GNU Parallel to run `watch-css` and `dev`.

By default microbrew.it listens to port 3000. This can be changed in config.coffee.

### Production
Installing requirements: `npm install -g forever && npm install --production`.

Make sure the configurations in config.coffee for the production setting is correct.

Running the project:
- `npm start`  - This runs the middleware in a forever container which restarts the process should it fail.

#### Docker
The Microbrew.it Middleware is also available as a Docker image at hub.docker.com.
To run the docker container>
`docker run -d -p 3000:3000 -e API_URL=http://dev.microbrew.it -e CLIENT_ID=localhost:3000 -e PORT=3000 microbrewit/microbrew-it-middleware:latest`

### A note on dependencies
We use `npm shrinkwrap` and `shrinkpack` to lock our dependencies.

## Licence
microbrew-it-middleware is licenced under MIT. For details see LICENCE.