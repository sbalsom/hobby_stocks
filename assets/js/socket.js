


import { Socket } from "phoenix"


let socket = new Socket("/stream", { params: {} })

socket.connect()

export default socket
