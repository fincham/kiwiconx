from collections import OrderedDict
from time import sleep

import gevent
from geventwebsocket import WebSocketApplication, WebSocketServer, Resource

class TTYApplication(WebSocketApplication):
    def socket_receiver(self):
        while True:
            gevent.socket.wait_read(self.sock.fileno())
            try:
                to_browser_buffer = self.sock.recv(100)
                for c in to_browser_buffer:
                    self.ws.send(c)
                    sleep(0.004)
            except:
                break

    def on_open(self):
        self.sock = gevent.socket.create_connection(('127.0.0.1', 4556))
        gevent.spawn(self.socket_receiver)

    def on_close(self, reason):
        self.sock.close()

    def on_message(self, message):
        try:
            self.sock.send(message)
        except:
            pass # ho ho ho

if __name__ == "__main__":
    WebSocketServer(
        ('', 5001),
        Resource(OrderedDict({'/tty/1': TTYApplication}))
    ).serve_forever()
