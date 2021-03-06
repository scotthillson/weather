var google_prep = function(){
  google.load("visualization", "1", {
    packages:["corechart"],
    callback: chart_prep
  });
}

var draw_chart = function(timeout,run){
  $('.again').removeClass('btn-success').addClass('btn-warning');
  $('.timer').removeClass('btn-danger').addClass('btn-info')
  setTimeout(function(){
    var data = new google.visualization.DataTable();
    data.addColumn('string','Hour');
    columns = gon.columns
    columns.forEach(function(c){
      data.addColumn('number',c);
    });
    var rows = gon.tables[run];
    $('.timer').html(run);
    rows.forEach(function(entry){
      console.log(entry[0]);
      data.addRow(entry);
    });
    trigger_chart(data);
  },timeout);
}

var animate = function(){
  var timeout = 400;
  runs.forEach(function(entry){
    draw_chart(timeout,entry);
    timeout = timeout + 4000
  });
  setTimeout(function(){
    $('.again').removeClass('btn-warning');
    $('.again').addClass('btn-success');
  },timeout);
}

var chart_prep = function(){
  chart = new google.visualization.LineChart(document.getElementById('temp-div'));
  options = {
    colors: gon.colors,
    animation:{duration: 3000,easing: 'linear'},
    legend : { position: 'none'}
  };
  draw_chart(100,runs[runs.length-1]);
}
var trigger_chart = function(data){
  chart.draw(data, options);
}
