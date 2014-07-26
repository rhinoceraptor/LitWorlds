define ["moo"], (moo) ->
	class Router extends Backbone.Router
		routes:
			"*path": "moo"

		moo: ->
			App.Views.mainView = new moo()
			App.Views.mainView.render()
