// Please see documentation at https://docs.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.

document.addEventListener('DOMContentLoaded', function () {
    var ctx = document.getElementById('teamChart').getContext('2d');

    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Won',
                data: wonData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Handle click events on the "Won" and "Lost" headings to switch data
    document.getElementById('wonHeader').addEventListener('click', function () {
        var dataset = myChart.data.datasets[0];
        if (dataset.label !== 'Won') {
            dataset.label = 'Won';
            dataset.data = wonData;
            dataset.backgroundColor = 'rgba(75, 192, 192, 0.2)';
            dataset.borderColor = 'rgba(75, 192, 192, 1)';
            myChart.update();
        }
    });

    document.getElementById('lostHeader').addEventListener('click', function () {
        var dataset = myChart.data.datasets[0];
        if (dataset.label !== 'Lost') {
            dataset.label = 'Lost';
            dataset.data = lostData;
            dataset.backgroundColor = 'rgba(255, 99, 132, 0.2)';
            dataset.borderColor = 'rgba(255, 99, 132, 1)';
            myChart.update();
        }
    });
});

