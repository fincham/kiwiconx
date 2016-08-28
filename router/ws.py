import random
from collections import OrderedDict
from time import sleep
import telnetlib
from telnetlib import DO, DONT, WILL, WONT, IAC, SB, SE, TTYPE, NOOPT, ECHO
import socket
import datetime

import gevent
from geventwebsocket import WebSocketApplication, WebSocketServer, Resource
import gevent.monkey; gevent.monkey.patch_all()

def stamp():
    return datetime.datetime.now().strftime('[%d/%b/%Y:%H:%M:%S] ')

class TTYApplication(WebSocketApplication):
    def socket_receiver(self):
        connected = False
        while True:
            try:
                vm_output = self.sock.read_some()
            except socket.timeout:
                pass # don't care about timeouts on reads
            except:
                vm_output = '' # if socket properly dies, simulate an EOF

            if connected == False:
                connected = True
                self.ws.send("Connected to %s.\r\n" % self.reverse_dns)
            if vm_output == '':
                print stamp() + "connection closed %s <-> %s (%s)" % (self.remote_host, self.host, self.reverse_dns)
                try:
                    self.ws.send('Connection closed by foreign host.\r\n')
                except:
                    pass # sometimes the WS is already dead, so, oh well...
                break
            else:
                for c in vm_output:
                    self.ws.send(c.decode('cp437').encode('utf8'))
                    sleep(0.001)

    def option_negotiator(self, socket, command, option):
        # telnet really sucks, if you wanted more proof:
        if command in (DO, DONT):
            if command == DO and option == TTYPE: # "can you tell me your terminal type?"
                socket.sendall(IAC + WILL + TTYPE) # "of course I will! let's do a whole pointless subnegotiation!"
            else: # for all other commands just refuse
                socket.sendall(IAC + WONT + option)
        elif command in (WILL, WONT):
            if command == WILL and option == ECHO: # "I could echo all characters back to you"
                socket.sendall(IAC + DO + ECHO) # "yes please, echo all characters"
            else: # all other offers just reply with a "don't"
                socket.sendall(IAC + DONT + option)
        elif command == SE: # a subnegotiation has started (hopefully for terminal-type)
            if self.sock.sbdataq == TTYPE + chr(1): # reply with terminal-type, chr(1) = "SEND", chr(0) = "IS"
                socket.sendall(IAC + SB + TTYPE + chr(0) + 'vt220' + IAC + SE) 

    def on_open(self):
        try:
            terminal = int(self.ws.path.split('/')[-1])
        except:
            terminal = random.choice([0,1,2])
        
        hosts = [
            '175.45.176.1', 
            '175.45.176.2',
            '175.45.176.3',
        ]
        reverse_dns = {
            '175.45.176.1': 'airgap.gundersonmolloy.co.nz',
            '175.45.176.2': 'storesecure.gundersonmolloy.co.nz',
            '175.45.176.3': 'commsecure.gundersonmolloy.co.nz',
        }

        self.host = hosts[terminal]
        self.reverse_dns = reverse_dns[self.host]
        self.remote_host = self.ws.environ['HTTP_X_FORWARDED_FOR']
        print stamp() + "websocket connection from %s to %s (%s)" % (self.remote_host, self.host, self.reverse_dns)
        self.ws.send("Trying %s...\r\n" % self.host)
        self.sock = telnetlib.Telnet()
        self.sock.set_option_negotiation_callback(self.option_negotiator)
        self.sock.open(self.host, 23)
        gevent.spawn(self.socket_receiver)
        
    def on_close(self, reason):
        try:
            self.sock.close()
        except:
            pass

    def on_message(self, message):
        try:
            self.sock.write(message)
        except:
            pass # yolo

if __name__ == "__main__":
    print stamp() + "starting up the tty router..."
    WebSocketServer(
        ('', 5000),
        Resource(OrderedDict({'/tty/[0-2]': TTYApplication, '/tty': TTYApplication}))
    ).serve_forever()
