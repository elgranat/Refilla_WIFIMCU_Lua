skt = net.new(net.TCP, net.SERVER)
net.on(skt, "accept", function(clt, ip, port)
    print("accept ip:" .. ip .. " port:" .. port .. " clt:" .. clt)
end)

net.on(skt, "receive", function(clt, data)
    print(" clt:" .. clt .. " Data:" .. data)
    net.send(clt, [[HTTP/1.1 200 OK
Server: WiFiMCU
Content-Type:text/html
Content-Length: 5000
Connection: close

<html><body>
<h1>Upload newprogram fdfhdfhdfhdfhdfhdfh</h1>
<input name="myFile" type="file">
</body></html>]])
end)


net.start(skt, 9092)