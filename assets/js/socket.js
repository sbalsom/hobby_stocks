


import { Socket } from "phoenix"


let socket = new Socket("/stream", { params: { token: "SFMyNTY.g2gDYQFuBgB28xe0dQFiAAFRgA.yELUI2UFcPc8LUX4Pfai3ZPcSJfZXYsVGKtelXoSAMA" } })

socket.connect()

export default socket
