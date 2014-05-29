$(document).ready ->
	$("#console").keypress (e) ->
		# Handle new lines
		if e.charCode is 13
			
			# Prevent newlines from being made in text input
			e.preventDefault()
			
			# Variables for console and backlog text areas
			$consoleIn = $("#console")
			$logOut = $("#backlog")
			
			# Append to backlog, then erase console
			# If there is no text already, don't add a newline.
			unless $logOut.val() is ""
				$logOut.val $logOut.val() + "\n" + $consoleIn.val()
			else
				$logOut.val $logOut.val() + $consoleIn.val()
			
			# Erase console
			$consoleIn.val ""
			
			# Automatically scroll the output
			$logOut.scrollTop $logOut[0].scrollHeight() - $logOut.height()
		return

	return