import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const chat_id = document.getElementById("chat_id").value;
  
  consumer.subscriptions.create({channel: "MessageChannel", chat_id: chat_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Channel Connected!!!");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("Channel Disconnected!!!");
    },

    received(data) {
      if ($('#type').val() == "user"){
        if (data.type == "User"){
          if (data.document == null) {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-end ms-auto text-white rounded pt-2"><div class="ms-auto rounded" style="padding: 10px; width: 20em; background: #24a64d"> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">You</div> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div></div></div>')
          } else {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-end ms-auto text-white rounded pt-2"><div class="ms-auto rounded" style="padding: 10px; width: 20em; background: #24a64d"> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">You</div> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content"><a href=' + data.document + '>Download</a></div></div></div>')
          }
        } else {
          if (data.document == null) {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-start me-auto text-white rounded pt-2"><div class="me-auto rounded" style="padding: 10px; width: 20em; background: #f5d120"> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">Tutor012345</div> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div></div></div>')
          } else {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-end me-auto text-white rounded pt-2"><div class="me-auto rounded" style="padding: 10px; width: 20em; background: #f5d120"> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">You</div> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div><div class="me-auto" style="width: -moz-fit-content; width: fit-content"><a href=' + data.document + '>Download</a></div></div></div>')
          }
        }
      } else {
        if (data.type == "Tutor"){
          if (data.document == null){
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-end ms-auto text-white rounded pt-2"><div class="ms-auto rounded" style="padding: 10px; width: 20em; background: #24a64d"> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">You</div> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div></div></div>')
          } else {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-end ms-auto text-white rounded pt-2"><div class="ms-auto rounded" style="padding: 10px; width: 20em; background: #24a64d"> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">You</div> <div class="ms-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div><div class="ms-auto" style="width: -moz-fit-content; width: fit-content"><a href=' + data.document + '>Download</a></div></div></div>')
          }
        } else {
          if (data.document == null) {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-start me-auto text-white rounded pt-2"><div class="me-auto rounded" style="padding: 10px; width: 20em; background: #f5d120"> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">User012345</div> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div></div></div>')
          } else {
            $('#messages').append('<div class="row mt-3"><div class="col-6 text-start me-auto text-white rounded pt-2"><div class="me-auto rounded" style="padding: 10px; width: 20em; background: #f5d120"> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">User012345</div> <div class="me-auto" style="width: -moz-fit-content; width: fit-content">' + data.html + '</div><div class="me-auto" style="width: -moz-fit-content; width: fit-content"><a href=' + data.document + '>Download</a></div></div></div>')
          }
        }
      }
    }
  });
});