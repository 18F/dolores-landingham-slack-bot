$(document).ready(function() {
  $('#quarterly').change(function() {
    if (this.checked) {
      $('#scheduled_message_days_after_start').val("0");
      $('.scheduled_message_days_after_start').hide();
      $('.scheduled_message_time_of_day').hide();
      $('.quarterly_message_explanation').show();
      $('#scheduled_message_message_time_frame').val('quarterly');

    }
    else {
      $('.scheduled_message_days_after_start').show();
      $('#scheduled_message_days_after_start').val("");
      $('.scheduled_message_time_of_day').show();
      $('.quarterly_message_explanation').hide();
      $('#scheduled_message_message_time_frame').val('onboarding');
    }
  });
});

