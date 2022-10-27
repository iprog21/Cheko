const tempusDominus = require("../../plugin/tempus-dominus")

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}


$(function(){
  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('homework_deadline'),
    {
      restrictions: {
        minDate: new Date().toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }    
  );

  window.datetimepicker2 = new tempusDominus.TempusDominus(
    document.getElementById('homework_internal_deadline'),
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

var prio = parseInt(0)

if ($('#homework_tutor_skills2').is(':checked')) {
  var skill = parseInt(100)
  
} else {
  var skill = parseInt(0)
}

if ($('#homework_tutor_samples2').is(':checked')) {
  var sample = parseInt(100)
} else {
  var sample = parseInt(0)
}


if ($('#homework_login_school2').is(':checked')) {
  var login = parseInt(200)
} else {
  var login = parseInt(0)
}


if ($('#homework_view_bidders2').is(':checked')) {
  var bid = parseInt(300)
} else {
  var bid = parseInt(0)
}

var new_price = 0

if ($('#homework_words').length){
  var def_price = parseInt($('#homework_words').val())
  prio = Math.round(( .30 * def_price));
  new_price = Math.round((def_price + skill + sample + login + bid))

  if ($('#homework_priority').is(':checked')) {
    new_price = Math.round(new_price + prio)
  }

  $('#testEstimate').html( '₱' + new_price )

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
  var def_price = parseInt(1000);
  
  new_price = def_price
  prio = Math.round(( .30 * def_price));
  console.log(new_price)
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

console.log(new_price)
console.log($('#homework_priority'))

$('#homework_priority2').on('change', function(){
  console.log(new_price)
  if ($('#homework_priority2').is(':checked')) {
    new_price = Math.round(new_price + prio)
    $('#testEstimate').html( '₱' + new_price )
    console.log(new_price)
  } else {
    new_price = Math.round(new_price - prio)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_login_school2').on('change', function(){
  if ($('#homework_login_school2').is(':checked')) {
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

$('#homework_view_bidders2').on('change', function(){
  if ($('#homework_view_bidders2').is(':checked')) {
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

$('#homework_tutor_samples2').on('change', function(){
  if ($('#homework_tutor_samples2').is(':checked')) {
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

$('#homework_tutor_skills2').on('change', function(){
  if ($('#homework_tutor_skills2').is(':checked')) {
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
