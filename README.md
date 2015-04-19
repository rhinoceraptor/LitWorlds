JavaScript Telnet Client for enCore MOO
---------------------------------------

### Basic Overview
This telnet client is designed to be a drop-in replacement for the Java applet one that ships with enCore. It is achieved by runnig a small Node.js server that sits in-between the LambdaMOO telnet server and the web browser client.

The Node.js server communicates with the web browser client using Socket.io, an easy to use implementation of Websockets. The Node.js server acts on behalf of each client for their telnet session, and handles the communication from the client to LambdaMOO for the duration of the client session.

To install this client in your LambdaMOO/enCore installation, you simply need to run the server (with the corrent configuration settings for the host and port of the telnet), and then modify two verbs in the enCore web interface to replace the Java applet with some HTML, CSS and JavaScript.

Detailed instructions for installing the verbs is contained in the verbs.md file.

### Documentation
Documentation for the server and the client is generated using Docco. It generates HTML you can view in your browser, with the comments side-by-side with the relevant code.

### Testing
The client code is tested using Jasmine, and the test runner in your web browser. Simply build the project (```Cake build```), and open the SpecRunner.html file.

The server code is tested using Jasmine-Node. To run the tests, first you have to have the server running. Run ```npm install```, then ```cake build``` in the server directory. Then, you can run the tests using the Cakefile target ```test``` by running ```cake test```.
