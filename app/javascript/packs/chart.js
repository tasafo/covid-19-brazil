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