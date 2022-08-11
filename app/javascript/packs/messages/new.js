// $( '#new_message' ).on('submit', function(){
//   // $( '#new_message' )[0].reset()
//   this.reset();
// })
var qnaId = $("#qna_id").val()
var chatId = $("#chat_id").val()

$( '#new_message' ).on("submit", function(event){
  if ( $("#type").val() == "user" ){

    $.ajax({
      type: "POST",
      url: "/qnas/" + qnaId + "/chats/" + chatId + "/messages?" + $( '#new_message' ).serialize(),
      data: "",
      success: function(data){
        $( '#new_message' ).each(function(){
          this.reset();
        });
      }
    })

    // $.post("/qnas/" + qnaId + "/chats/" + chatId + "/messages", $( '#new_message' ).serialize(), function(data){
    //   $( '#new_message' ).each(function(){
    //     this.reset();
    //   });
    // })

  } 
})



// else if( $("#type").value() == "tutor" ){

// }

// $.post()
// $( '#new_message' ).each(function(){
//   this.reset();
// });
console.log($( '#new_message' ).serialize())