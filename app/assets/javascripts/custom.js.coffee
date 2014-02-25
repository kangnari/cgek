updateCountdown = ->
	remaining = 500 - jQuery('#post_content').val().length
	jQuery('.countdown').text(remaining + ' characters remaining')

jQuery ->
	updateCountdown()
	$('#post_content').change updateCountdown
	$('#post_content').keyup updateCountdown