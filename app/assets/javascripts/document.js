// 01.17.2015 - Scott Hillson - Initial Version

var runs = gon.runs.reverse();
var options;
var chart;
var ready = function(){
  google_prep();
  $(document).on('click','.again',animate);
}
$(document).ready(ready);
$(document).on('page:load',ready);

var get_param = function(variable){
  var query = location.search.substring(1);
  var vars = query.split('&');
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if(pair[0] == variable){
      return pair[1];
    }
  }
}
