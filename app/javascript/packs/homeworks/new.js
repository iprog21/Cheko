import "../../plugin/jquery.steps.min.js"

$('#new_homework').steps({
  headerTag: "h3",
  bodyTag: "stuff",
  transitionEffect: "fade",

  // enableKeyNavigation: false,
  // onStepChanging: function(event, currentIndex, newIndex){
  //   if (currentIndex > newIndex) {
  //     return true;
  //   }
  //   var form = $(this);
  //   if (currentIndex < newIndex) {
  //     $(".body:eq(" + newIndex + ") label.error", form).remove();
  //     $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
  //   }
  //   form.validate({
  //     rules: {
  //       "puzzle[no_of_users]": {
  //         required: true,
  //         number: true
  //       }
  //     }
  //   }).settings.ignore = ":disabled,:hidden";
  //   form.valid();
  //   var $cat_grp = $("input:checkbox[name='selected_categories[]']");
  //   $('#catAlert').removeClass("d-none")
  //   if($cat_grp.is(":checked")){
  //     $('#catAlert').addClass("d-none");
  //     return form.valid();
  //   }
    
  // },
  onFinished: function (event, currentIndex) {
      $("#new_homework").submit();
    }
})

$('div .steps').addClass("list-group list-group-horizontal")