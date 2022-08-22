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


// document.getElementById('homework_deadline'),
//     {
//       restrictions: {
//         minDate: new Date().toDateString()
//       },
//       display: {
//         theme: getCookie("theme"),
//       }
//     }