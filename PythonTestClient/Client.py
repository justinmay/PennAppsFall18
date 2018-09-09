from socketIO_client import SocketIO, BaseNamespace

class ChatNamespace(BaseNamespace):

    def on_aaa_response(self, *args):
        print('on_aaa_response', args)

class NewsNamespace(BaseNamespace):

    def on_aaa_response(self, *args):
        print('on_aaa_response', args)

socketIO = SocketIO('2f2f976f.ngrok.io', 5000)
chat_namespace = socketIO.define(ChatNamespace, '/test')
news_namespace = socketIO.define(NewsNamespace, '/private')

chat_namespace.send('aaa')
#news_namespace.emit('aaa')
socketIO.wait(seconds=1)