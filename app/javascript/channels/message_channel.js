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
      $('#content').val("");
      if ($('#type').val() == "user"){
        if (data.type == "User"){
          $('#messages').append('<div class="text-end">' + data.html + '</div>')
        } else {
          $('#messages').append('<div class="text-start">' + data.html + '</div>')
        }
      } else {
        if (data.type == "Tutor"){
          $('#messages').append('<div class="text-end">' + data.html + '</div>')
        } else {
          $('#messages').append('<div class="text-start">' + data.html + '</div>')
        }
      }
    }
  });
});