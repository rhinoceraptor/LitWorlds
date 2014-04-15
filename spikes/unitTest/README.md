# Unit Testing Node.js With Mocha and Chai
## Setup
Install mocha globally using npm
```
npm install -g mocha`
```
## Run Test
To run the test with mocha:
At the unitTest directory root `mocha`
Anywhere else `mocha path/to/unitTest/test/`

### Change the mocha reporter
`mocha -R <reporter>`

My Favorite Reporters
* spec
* nyan

[Mocha Reporters](visionmedia.github.io/mocha/#reporters)

## How to use app.js
`./app.js -h` diplays help
Example:
	`./app.js -q=".js"`
	Displays .js files with default depth