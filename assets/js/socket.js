


import { Socket } from "phoenix"


let socket = new Socket("/stream", { params: { token: window.userToken } })

socket.connect()

export default socket
