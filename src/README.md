# Server Setup
Make sure Node is installed.

Using **NPM** install Coffescript and Forever

* `npm install -g coffee-script forever`

Then in the `server` directory run:

* `npm install`
* `cake build`

Repeat npm install and cake build in the client directory.

# Running the Server
Using Forever in src (this) directory, run:

* `forever start ./dist/server.js`

###Please note that apache2 must be configured to listen to port 81 and port 8080 must be free
`/etc/apache2/ports.conf` is the file to edit to port 81
server.js is bound to port 80.

# Making Docs
Make sure Docco is installed
`npm install -g docco`

In each directory (server and client) install `which`

* `npm install which`

Then run `cake docs`

Documentation will be created in the `docs` folder of each directory.

