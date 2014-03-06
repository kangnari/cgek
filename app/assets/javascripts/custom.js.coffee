updateCountdown = ->
	remaining = 500 - jQuery('.text_countdown').val().length
	jQuery('.countdown').text(remaining + ' characters remaining')

jQuery ->
	updateCountdown()
	$('.text_countdown').on('input', updateCountdown)