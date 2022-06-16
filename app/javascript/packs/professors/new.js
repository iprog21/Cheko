function getAve(){
  var eas = parseInt($("#professor_easiness").val());
  var eff = parseInt($("#professor_effectiveness").val());
  var cha = parseInt($("#professor_life_changing").val());
  var wor = parseInt($("#professor_light_workload").val());
  var len = parseInt($("#professor_leniency").val());

  var average = eas + eff + cha + wor + len
  console.log(average)
  var average = average / 5
  console.log(average)

  $("#percent_av").empty()
  $("#percent_av").append(average + "%");

  $("#professor_average").val(average)
}

// MAIN METRICS
$("#professor_easiness").on("input", function(){
  getAve()
  $("#percent").empty()
  $("#percent").append($("#professor_easiness").val() + "%")
})

$("#professor_effectiveness").on("input", function(){
  getAve()
  $("#percent_ef").empty()
  $("#percent_ef").append($("#professor_effectiveness").val() + "%")
})

$("#professor_life_changing").on("input", function(){
  getAve()
  $("#percent_lf").empty()
  $("#percent_lf").append($("#professor_life_changing").val() + "%")
})

$("#professor_light_workload").on("input", function(){
  getAve()
  $("#percent_lw").empty()
  $("#percent_lw").append($("#professor_light_workload").val() + "%")
})

$("#professor_leniency").on("input", function(){
  getAve()
  $("#percent_len").empty()
  $("#percent_len").append($("#professor_leniency").val() + "%")
})

////////////////////////
// ADDITIONAL METRICS //
////////////////////////

$("#professor_a_able").on("input", function(){
  $("#percent_aable").empty()
  $("#percent_aable").append($("#professor_a_able").val() + "%")
})

$("#professor_b_pls_able").on("input", function(){
  $("#percent_bbable").empty()
  $("#percent_bbable").append($("#professor_b_pls_able").val() + "%")
})

$("#professor_c_able").on("input", function(){
  $("#percent_cable").empty()
  $("#percent_cable").append($("#professor_c_able").val() + "%")
})

$("#professor_b_able").on("input", function(){
  $("#percent_bable").empty()
  $("#percent_bable").append($("#professor_b_able").val() + "%")
})

//////////////////
// BATCH RANGE //
/////////////////

$("#professor_batch1_able").on("input", function(){
  getAve()
  $("#percent_b1able").empty()
  $("#percent_b1able").append($("#professor_batch1_able").val() + "%")
})

$("#professor_batch2_able").on("input", function(){
  getAve()
  $("#percent_b2able").empty()
  $("#percent_b2able").append($("#professor_batch2_able").val() + "%")
})

$("#professor_batch3_able").on("input", function(){
  getAve()
  $("#percent_b3able").empty()
  $("#percent_b3able").append($("#professor_batch3_able").val() + "%")
})

$("#professor_batch4_able").on("input", function(){
  getAve()
  $("#percent_b4able").empty()
  $("#percent_b4able").append($("#professor_batch4_able").val() + "%")
})

