// $(document).on("turbolinks:request-start", function(){
//   $(".spinner").show();
// });

// $(document).on("turbolinks:request-end", function(){
//   $(".spinner").hide();
// });



// $(function() {
//     document.addEventListener('turbolinks:request-start', function() {
//         $(".spinner").show();
//     });

//     document.addEventListener("turbolinks:request-end", function(){
//         $(".spinner").hide();
//     });
// });

// Turbolinks.ProgressBar.enable();



// $(document).on("turbolinks:load", function() {

//   // hide spinner
//   $(".spinner").hide();

// });

// $(document).on("page:fetch", function(){
//   $(".spinner").show();
// });

// $(document).on("page:receive", function(){
//   $(".spinner").hide();
// });

// $(document).on("turbolinks:request-start", function(){
//   $(".spinner").show();
// });

// $(document).on("turbolinks:request-end", function(){
//   $(".spinner").hide();
// });




// $(document).on 'page:fetch', ->
//   $('#spinner').show()
//   return
// $(document).on 'page:receive', ->
//   $('#spinner').hide()
//   return


// $(document).on("turbolinks:request-start", function(){
//   $("#spinner").show();
//   return
// });

$(document).on("turbolinks:load", function(){
  // $(".modal").hide();
  // return
  $("#searchBtn").click(function(){
  	$(".modal").show();
  })
});