jQuery(function(){
	$('.again').on('click',prep);
  $(document).on('page:load',prep);
});

var options;
var chart;
var runs = gon.runs;
runs.reverse();
google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(prep);
drawchart = function(timeout,run){
	$('.again').removeClass('btn-success');
	$('.again').addClass('btn-warning');
	setTimeout(function(){
		var data = new google.visualization.DataTable();
		data.addColumn('string','Hour');
		data.addColumn('number','Highball');
		data.addColumn('number','Lowball');
		data.addColumn('number','Precipitation');
		var rows = new Array();
		rows = gon.tables[run];
		$('.timer').html(run);
		rows.forEach(function(entry){
			data.addRow(entry);
		});
		triggerChart(data);
	},timeout);
}
function prep(){
	chart = new google.visualization.LineChart(document.getElementById('temp-div'));
	options = {
		colors: ['Red','Purple','Blue'],
		animation:{duration: 3000,easing: 'linear'}
	};
	var timeout = 400;
	runs.forEach(function(entry){
		drawchart(timeout,entry);
		timeout = timeout + 4000
	});
	setTimeout(function(){
		$('.again').removeClass('btn-warning');
		$('.again').addClass('btn-success');
	},timeout);
}
function triggerChart(data){
	chart.draw(data, options);
}