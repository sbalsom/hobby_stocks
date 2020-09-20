import Chart from 'chart.js';

let Ticker = {
  init(socket) {

    const urlParams = new URLSearchParams(window.location.search);
    let ticker = urlParams.get('ticker');
    let channelType = urlParams.get('channel');
    if (ticker && channelType) {

      var ctx = document.getElementById('myChart').getContext('2d');
      var myChart = new Chart(ctx, {
        type: 'scatter',
        data: {

          datasets: [{
            label: 'Stock Price (last 30 sales)',
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


      if (channelType == "ticker") {
        let channel = socket.channel(`ticker:${ticker}`, {})
        let dataset = myChart.data.datasets[0].data

        let price = document.getElementById("price");
        let time = document.getElementById("time")
        let size = document.getElementById("size")
        let type = document.getElementById("type")

        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) });

        channel.on("ticker_event", payload => {
          console.log(payload)

          let newPrice = parseFloat(payload["price"])
          let newDate = new Date(payload["time"])
          let side = payload["side"]

          let newData = {
            t: newDate, y: newPrice
          }
          dataset.push(newData)
          console.log(dataset.length)
          // if (dataset.length > 100000) {
          //   dataset.shift();
          // }
          myChart.update();
          console.log(dataset)
          price.innerHTML = `${newPrice}`
          size.innerHTML = `${payload["last_size"]}`
          time.innerHTML = `${newDate.toLocaleString()}`
          type.innerHTML = `${side}`
        });
      } else if (channelType == "match") {
        let channel = socket.channel(`match:${ticker}`, {})

        let price = document.getElementById("price");
        let time = document.getElementById("time")
        let size = document.getElementById("size")
        let type = document.getElementById("type")

        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) });



        channel.on("match_event", payload => {
          console.log(payload)
          let dataset = myChart.data.datasets[0].data

          let newPrice = parseFloat(payload["price"])
          let newDate = new Date(payload["time"])
          let side = payload["side"]
          let newData = {
            t: newDate, y: newPrice
          }
          dataset.push(newData)

          if (dataset.length > 30) {
            dataset.shift();
          }
          myChart.update();
          console.log(dataset)
          price.innerHTML = `${newPrice}`
          size.innerHTML = `${payload["size"]}`
          time.innerHTML = `${newDate.toLocaleString()}`
          type.innerHTML = `${side}`
        });
      }

    }
  }
}

export default Ticker;
