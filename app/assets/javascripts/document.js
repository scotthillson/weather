var runs = gon.runs.reverse();
var options;
var chart;
var ready = function(){
  google_prep;
  $(document).on('click','.again',google_prep);
}
$(document).ready(ready);
$(document).on('page:load',ready);