$(document).ready(function() {
  $('#quarterly').change(function() {
    if (this.checked) {
      $('.onboarding-message-fields').hide();
      $('.quarterly-message-fields').show();
      $('#scheduled_message_type').val('quarterly');
    }
    else {
      $('.onboarding-message-fields').show();
      $('.quarterly-message-fields').hide();
      $('#scheduled_message_type').val('onboarding');
    }
  });
});

