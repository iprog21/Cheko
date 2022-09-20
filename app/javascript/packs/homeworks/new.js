import "../../plugin/jquery.steps.min.js"
import "../../plugin/jquery.filter_input"
import "jquery-validation"
import "bootstrap-datepicker"
// import "../../plugin/tempus-dominus"
import "../../plugin/jQuery-provider"
const tempusDominus = require("../../plugin/tempus-dominus")

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

$(function(){
  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('datetimepicker1'),
    {
      restrictions: {
        minDate: new Date().toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }
  );
})

$(document).ready(function(){
  $('#user_first_name').filter_input({regex:'[a-zA-Z]'});
  $('#user_last_name').filter_input({regex:'[a-zA-Z]'});
})

$('#new_homework').steps({
  headerTag: "h3",
  bodyTag: "stuff",
  transitionEffect: "fade",

  // enableKeyNavigation: false,
  onStepChanging: function(event, currentIndex, newIndex){
    if (currentIndex > newIndex) {
      return true;
    }
    $("#new_homework").validate({
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
    }).settings.ignore = ":disabled,:hidden";
    return $("#new_homework").valid();
  },
  onFinishing: function (event, currentIndex){
    
    console.log($("#new_homework") .valid())
    return $("#new_homework") .valid();
  },
  onFinished: function (event, currentIndex) {
    $("#new_homework").submit();
  }
})

$('div .steps').addClass("list-group list-group-horizontal")