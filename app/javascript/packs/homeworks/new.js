import "../../plugin/jquery.steps.min.js"
import "jquery-validation"
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
        email: {
          required: true,
          email: true,
          remote: "/check-email"
        }
      }
    }).settings.ignore = ":disabled,:hidden";
    return $("#new_homework").valid();
  },
  onFinishing: function (event, currentIndex){
    $("#new_homework").validate({
      rules: {
        email: {
          required: true,
          email: true,
          remote: "/check-email"
        }
      }
    }).settings.ignore = ":disabled";
    return $("#new_homework") .valid();
  },
  onFinished: function (event, currentIndex) {
    $("#new_homework").submit();
  }
})

$('div .steps').addClass("list-group list-group-horizontal")