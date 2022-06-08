
document.addEventListener("turbolinks:load", function () {
  require( 'datatables.net-dt' );
  $('#datatable').DataTable();

  $('.homeworks-scrollX').DataTable({
    scrollX: true,
  });
})