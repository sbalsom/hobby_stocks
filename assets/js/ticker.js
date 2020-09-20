import Chart from 'chart.js';

let price = document.getElementById("price");
let time = document.getElementById("time")
let size = document.getElementById("size")
let type = document.getElementById("type")

function writeToPage(p, d, sz, sd) {
  price.innerHTML = `${p}`
  time.innerHTML = `${d.toLocaleString()}`
  size.innerHTML = `${sz}`
  type.innerHTML = `${sd}`
}

function writeToChart(price, time) {
  let newData = {
    t: time, y: price
  }
  let dataset = myChart.data.datasets[0].data
  dataset.push(newData)
  if (dataset.length > 200) {
    dataset.shift();
  }
  myChart.update();

}

function extractData(set) {
  return { t: new Date(set["time"]), y: parseFloat(set["price"]) }
}

function writeAllToChart(cache) {
  console.log("writing all ")
  console.log(cache.length)
  myChart.data.datasets[0].data = cache.map(extractData).sort(function (a, b) {
    return a.t - b.t;
  })
  myChart.update();
}

let ctx = document.getElementById('myChart').getContext('2d');
let myChart = new Chart(ctx, {
  type: 'scatter',
  data: {

    datasets: [{
      label: 'Stock Price (last 200 sales)',
      showLine: true,
      data: [],
      borderWidth: 1,
      color: 'white',
      borderColor: 'rgba(189, 23, 59, 1)',
      backgroundColor: 'rgba(176, 245, 102, 0.3)',
      pointBorderColor: 'rgba(222, 214, 236, 1.00)',
      capBezierPoints: false,
      tension: 0,
      stepped: true,
      hitRadius: 0.5,
      fill: 'origin'
    }]
  },
  options: {
    legend: {
      labels: {
        fontColor: '#FFFFFF'
      }
    },
    scales: {
      xAxes: [{
        type: 'time',
        position: 'bottom'
      }],
      yAxes: [{
        ticks: {
          precision: 0.001,
          fontColor: '#FFFFFF'
        }
      }]
    }
  }
});

let Ticker = {
  init(socket) {

    const urlParams = new URLSearchParams(window.location.search);
    let ticker = urlParams.get('ticker');
    let channelType = urlParams.get('channel');

    if (ticker && channelType) {
      if (channelType == "ticker") {

        let channel = socket.channel(`ticker:${ticker}`, {})

        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) });

        channel.on("cache_load", payload => {
          writeAllToChart(payload["cache"]);
        });
        channel.on("ticker_event", payload => {
          let newPrice = parseFloat(payload["price"])
          let newDate = new Date(payload["time"])
          let newSide = payload["side"]
          let newSize = payload["last_size"]

          writeToPage(newPrice, newDate, newSize, newSide);
          writeToChart(newPrice, newDate)

        });

      } else if (channelType == "match") {
        let channel = socket.channel(`match:${ticker}`, {})

        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) });

        channel.on("match_event", payload => {
          let newPrice = parseFloat(payload["price"])
          let newDate = new Date(payload["time"])
          let newSide = payload["side"]
          let newSize = payload["size"]

          writeToPage(newPrice, newDate, newSize, newSide)
          writeToChart(newDate, newPrice);

        });
      }

    }
  }


}

export default Ticker;
