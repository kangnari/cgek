updateCountdownPost = ->
	remaining = 500 - jQuery('#post_content').val().length
	jQuery('.countdownPost').text(remaining + ' characters remaining')

jQuery ->
	updateCountdownPost()
	$('#post_content').change updateCountdownPost
	$('#post_content').keyup updateCountdownPost