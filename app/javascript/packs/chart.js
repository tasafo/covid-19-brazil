import Chart from 'chart.js'

var ctx = document.getElementById('casesByDateChat').getContext('2d');
var myChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: DATES,
        datasets: [
          {
            label: 'Casos confirmados',
            data: CASES,
            backgroundColor: '#ccc',
            borderColor: '#000',
            borderWidth: 1
          },
          {
            label: 'Mortes',
            data: DEATHS,
            backgroundColor: '#FF0000',
            borderColor: '#FF0000',
            borderWidth: 1
          }
        ]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        }
    }
});

google.load('visualization', '1', {
  'packages': ['geochart', 'table']
});
google.setOnLoadCallback(drawRegionsMap);

function drawRegionsMap() {
    console.log(DEATHS_BY_UF);
  var data = google.visualization.arrayToDataTable(DEATHS_BY_UF);

  var view = new google.visualization.DataView(data)
  view.setColumns([0, 1])

  var options = {
      region: 'BR',
      resolution: 'provinces',
      width: 556,
      height: 347
  };

  var chart = new google.visualization.GeoChart(
  document.getElementById('chart_div'));
  chart.draw(data, options);

  var geochart = new google.visualization.GeoChart(
  document.getElementById('chart_div'));
  var options = {
      region: 'BR',
      resolution: 'provinces',
      width: 556,
      height: 347,
      colorAxis: {
          colors: ['#acb2b9', '#2f3f4f']
      } // orange to blue 
  };
  google.visualization.events.addListener(geochart, 'regionClick', function (eventData) {
      // maybe you want to change the data table here...
      options['region'] = eventData.region;
      options['resolution'] = 'provinces';
      options['displayMode'] = 'markers';

      var data = google.visualization.arrayToDataTable([
      // Add Results for Individual State
      // Format needs to match what is below so that it locates the correct position
      // Additional information can be added to array
      // Uses first value in 2nd column to determine scale for markers
      // Use AJAX to load this on regionClick
      ['City', 'Views'],
          ['Recife, PE', 200],
          ['Manaus, AM', 300],
          ['Santos, SP', 400],
          ['Campinas, SP', 400],

      ]);

      geochart.draw(data, options);
      var table = new google.visualization.Table(document.getElementById('table'));
      table.draw(data, null);

  });
  geochart.draw(data, options);

};