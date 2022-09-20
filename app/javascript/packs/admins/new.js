import "../../plugin/jquery.filter_input"
$(document).ready(function(){
  $('#admin_first_name').filter_input({regex:'[a-zA-Z]'});
  $('#user_last_name').filter_input({regex:'[a-zA-Z]'});
})