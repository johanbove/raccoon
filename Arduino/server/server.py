import SimpleHTTPServer
import SocketServer
from urlparse import urlparse, parse_qs

PORT = 8000


class MyRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):

        params = parse_qs(urlparse(self.path).query)


        print(params)
        if params:
            #write to file
            print "file openinig for write..."
            f = open('data.txt', 'w')
            print "writing..."
            f.write(str(params['set'][0]))
            print "writed"
            f.close()
            print "file closed"

            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write("OK")
        else:
            print "file openinig for read..."
            f = open('data.txt', 'r')
            print 'reading'
            data = f.read(1)
            print 'done'
            f.close()
            print 'file closed'

            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(data)

        return

Handler = MyRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
