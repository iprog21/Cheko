
// document.addEventListener("turbolinks:load", function () {
  require( 'datatables.net-dt' );
  $('#datatable').DataTable();

  $('.datatableBasic').DataTable();

  $('.homeworks-scrollX').DataTable({
    scrollX: true,
  });

  console.log("datatable log")
// });
