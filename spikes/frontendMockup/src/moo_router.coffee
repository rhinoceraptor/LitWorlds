define ["moo"], (moo) ->
	class moo_router extends Backbone.Router
		routes:
			"#text": "text_mode"
			"#mixed": "mixed_mode"
			"#graphic": "graphic_mode"
			"*other": "moo"

		moo: ->
			#App.Views.mainView = new moo
			App.Views.main_view.render()
