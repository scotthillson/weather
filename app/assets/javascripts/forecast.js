function google_prep(){
  google.load("visualization", "1", {
    packages:["corechart"],
    callback: chart_prep
  });
}

function draw_chart(timeout,run){
	$('.again').removeClass('btn-success').addClass('btn-warning');
  $('.timer').removeClass('btn-danger').addClass('btn-info')
	setTimeout(function(){
		var data = new google.visualization.DataTable();
		data.addColumn('string','Hour');
		data.addColumn('number','Highball');
		data.addColumn('number','Lowball');
		data.addColumn('number','Precipitation');
		var rows = new Array();
		rows = gon.tables[run];
    console.log(gon.tables);
		$('.timer').html(run);
		rows.forEach(function(entry){
			data.addRow(entry);
		});
		trigger_chart(data);
	},timeout);
}

function chart_prep(){
	chart = new google.visualization.LineChart(document.getElementById('temp-div'));
	options = {
		colors: ['Red','Purple','Blue'],
		animation:{duration: 3000,easing: 'linear'}
	};
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

function trigger_chart(data){
	chart.draw(data, options);
}
