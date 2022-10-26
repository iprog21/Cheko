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
  $('#user_first_name').filter_input({regex:'[a-zA-Z ]+'});
  $('#user_last_name').filter_input({regex:'[a-zA-Z ]+'});
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

var prio = parseInt(0)

var skill = parseInt(0)

var sample = parseInt(0)

var login = parseInt(0)

var bid = parseInt(0)

var new_price = 0

if ($('#homework_words').length){
  var def_price = 0
  $('#homework_words').on('change', function(){
    def_price = Math.round(parseInt($('#homework_words').val()) * parseInt($('input[name="homework[tutor_category]"]:checked').data("bal")));

    console.log(parseInt($('input[name="homework[tutor_category]"]:checked').data("bal")))
    prio = Math.round(( .30 * def_price));
    new_price = Math.round((def_price + skill + sample + login + bid))

    if ($('#homework_priority').is(':checked')) {
      new_price = Math.round(new_price + prio)
    }

    $('#testEstimate').html( '₱' + new_price )
  })
} else {
  var def_price = parseFloat(1000);
  new_price = def_price
  prio = Math.round(( .30 * def_price));
  $('#testEstimate').html( '₱' + new_price )
}

$('input[name="homework[tutor_category]"]').on('change', function(){
  var new_def_price = Math.round( parseInt(def_price) * parseInt($(this).data("bal")))
  new_price = Math.round((new_def_price + skill + sample + login + bid))
  prio = Math.round(( .30 * new_def_price));
  if ($('#homework_priority').is(':checked')) {
    new_price = Math.round(new_price + prio)
  }

  $('#testEstimate').html( '₱' + new_price )
})



$('#homework_priority').on('change', function(){
  if ($('#homework_priority').is(':checked')) {
    new_price = Math.round(new_price + prio)
    $('#testEstimate').html( '₱' + new_price )

  } else {
    new_price = Math.round(new_price - prio)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_login_school').on('change', function(){
  if ($('#homework_login_school').is(':checked')) {
    login = parseInt(200)
    new_price = Math.round(new_price + login)
    $('#testEstimate').html( '₱' + new_price )
  } else {
    login = parseInt(200)
    new_price = Math.round(new_price - login)
    login = parseInt(0)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_view_bidders').on('change', function(){
  if ($('#homework_view_bidders').is(':checked')) {
    bid = parseInt(300)
    new_price = Math.round(new_price + bid)
    $('#testEstimate').html( '₱' + new_price )
  } else {
    bid = parseInt(300)
    new_price = Math.round(new_price - bid)
    bid = parseInt(0)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_tutor_samples').on('change', function(){
  if ($('#homework_tutor_samples').is(':checked')) {
    sample = parseInt(100)
    new_price = Math.round(new_price + sample)
    $('#testEstimate').html( '₱' + new_price )
  } else {
    sample = parseInt(100)
    new_price = Math.round(new_price - sample)
    sample = parseInt(0)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_tutor_skills').on('change', function(){
  if ($('#homework_tutor_skills').is(':checked')) {
    skill = parseInt(100)
    new_price = Math.round(new_price + skill)
    $('#testEstimate').html( '₱' + new_price )
  } else {
    skill = parseInt(100)
    new_price = Math.round(new_price - skill)
    skill = parseInt(0)
    $('#testEstimate').html( '₱' + new_price )
  }
})
