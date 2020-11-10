


import { Socket } from "phoenix"


let socket = new Socket("/stream")

socket.connect()

export default socket
