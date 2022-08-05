import "jquery-validation"
$("#new_user").validate({
  rules: {
    "user[email]": {
      remote: {
        url: window.location.origin + "/check-email"
      }
    },
    "user[password]": {
      minlength: 6
    },
    "user[password_confirmation]": {
      equalTo: "#user_password"
    }
  },

  messages: {
    "user[email]": "Email is already been used"
  }
});