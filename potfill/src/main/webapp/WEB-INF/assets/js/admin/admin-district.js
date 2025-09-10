/* Chart.js 적용 */

// --- 원형 차트 (완료율) ---
const ctxDonut = document.getElementById('circleChart').getContext('2d');

const dataDounut = {
    labels: ['완료', '미완료'],
    datasets: [{
        data: [COMPLETED_COUNT, NEW_COUNT + PROCESSING_COUNT],
        backgroundColor: ['#00E88B', '#D0D0D0'],
        borderWidth: [0, 5],
        hoverOffset: 1
    }]
};

const configDonut = {
    type: 'doughnut',
    data: dataDounut,
    options: {
        cutout: '80%',
        responsive: false,
        elements: { arc: { borderWidth: 0 } },
        plugins: {
            legend: { display: false },
            tooltip: { enabled: true }
        }
    },
    plugins: [{
        id: 'centerText',
        beforeDraw: (chart) => {
            const { width, height, ctx } = chart;
            ctx.save();

            const total = TOTAL_COUNT;
            const done = COMPLETED_COUNT;
            const percent = ((done / total) * 100).toFixed(1) + "%";

            ctx.font = "14px Arial";
            ctx.fillStyle = "#333";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";

            const centerX = width / 2;
            const centerY = height / 2;

            ctx.fillText("Total : " + total, centerX, centerY - 20);
            ctx.fillText("완료 : " + done, centerX, centerY - 5);

            ctx.font = "bold 20px Arial";
            ctx.fillText(percent, centerX, centerY + 20);

            ctx.restore();
        }
    }]
};

new Chart(ctxDonut, configDonut);


// --- 막대 차트 (최근 7일간 접수/완료 현황) ---
const dates = DAILY_COUNTS.map(dc => dc.date);
const receivedData = DAILY_COUNTS.map(dc => dc.received);
const completedData = DAILY_COUNTS.map(dc => dc.completed);

const barData = {
    labels: dates,
    datasets: [
        {
            label: '완료',
            data: completedData,
            backgroundColor: '#D9D9D9',
            borderSkipped: false,
            maxBarThickness: 15
        },
        {
            label: '접수',
            data: receivedData,
            backgroundColor: '#B1F4F0',
            borderSkipped: false,
            maxBarThickness: 15
        }
    ]
};

const barConfig = {
    type: 'bar',
    data: barData,
    options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { intersect: false },
        layout: { padding: 10 },
        scales: {
            x: {
                stacked: true,
                grid: { display: false },
                ticks: {
                    callback: function(value, index) {
                        const d = new Date(this.getLabelForValue(index));
                        return (d.getMonth() + 1) + '/' + d.getDate();
                    },
                    font: { size: 12 }
                }
            },
            y: {
                stacked: true,
                beginAtZero: true,
                grid: { color: '#f0f0f0' },
                ticks: { stepSize: 1 }
            }
        },
        plugins: {
            legend: { position: 'right', labels: { usePointStyle: true, padding: 20 } },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return context.dataset.label + ': ' + context.parsed.y + '건';
                    }
                }
            },
            datalabels: {
                color: 'white',
                anchor: 'center',
                align: 'center',
                font: { weight: 'bold', size: 12 },
                formatter: function(value) {
                    return value === 0 ? '' : value;
                }
            }
        }
    },
    plugins: [ChartDataLabels]
};

new Chart(document.getElementById('barChart').getContext('2d'), barConfig);