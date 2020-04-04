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
      }
  };
  geochart.draw(data, options);
};