$(function(){
	var toMakeElastic = ['#scheduled_message_body'];

	$.each(toMakeElastic, function (i, selector) {
		$(selector).elastic();
	});

});
