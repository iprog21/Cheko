
import $ from 'jquery';
import DataTable from 'datatables.net-dt';
require('datatables.net-dt');
import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

  if (window.location.pathname == "/managers/homeworks" || window.location.pathname == "/admins/homeworks") {

    const adminTablePending = $('#admin-homework-table #pending').DataTable({
      scrollX: true,
      order: [[0, 'desc']],
    });

    const managerTablePending = $('#manager-homework-table #pending').DataTable({
      scrollX: true,
      order: [[0, 'desc']],
    });


    consumer.subscriptions.create("HomeworkUpdateChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log("HOMEWORK UPDATE CHANNEL >>> ");
        console.log(data);

        var fromControllerAction = data.controller_action
        var homework = data.data.homework

        console.log(homework);

        if (fromControllerAction == "create") {
          if (document.getElementById('admin-homework-table')) {

            var currentAdminID = $("#admin-homework-table").data("admin-id");
            var currentAdminRole = $("#admin-homework-table").data("admin-role");

            var actionStr = '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-primary font-16 mr-3"></div></a>';

            if (homework.admin_id == currentAdminID || currentAdminRole == 'super_admin') {
              actionStr += '<a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-secondary font-16 mr-3"></div></a><a data-method="put" href="/admins/homeworks/' + homework.id + '/assign"><div class="fas fa-circle-check text-success font-16 mr-3"></div></a>';
            } else if (homework.admin_id == null) {
              actionStr += '<a data-method="put" href="/admins/homeworks/' + homework.id + '/assign"><div class="fas fa-circle-check text-success font-16 mr-3"></div></a>';
            }

            adminTablePending.row.add([
              homework.id,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.deadline,
              homework.subject,
              homework.tutor_category,
              homework.words,
              homework.tutor_samples,
              homework.tutor_skills,
              homework.view_bidders,
              homework.priority,
              homework.login_school,
              homework.admin,
              actionStr,
            ]).draw(true);
          } else if (document.getElementById('manager-homework-table')) {

            managerTablePending.row.add([
              homework.id,
              homework.name,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.internal_deadline,
              homework.subject,
              homework.details,
              homework.tutor_category,
              homework.words,
              homework.priority,
              homework.login_school,
              homework.user,
              homework.tutor,
              homework.sub_tutor,
              homework.hours_late,
              homework.prof,
              homework.grade,
              homework.status,
              '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16-mr-3"></div></a><a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-primary font-16 mr-3"></div></a>']).draw(true);
          }
        }

      }
    });
  }

});
