from flask import Flask
from flask_restful import Api
from flask_jwt import JWT
from flask_socketio import SocketIO, emit, send

from security import authenticate, identity
from user_resource import UserRegister
import player_resource
from command_resource import Command
#from resources.player import Player, PlayerList
from session_resource import Session, SessionList


# create a flask instance
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'  # we are using sqlite but any sql db could be used
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # flask has better track modifications systems
app.secret_key = 'dante'  # secret key that is used to encrypt the access token
api = Api(app)  # create the api instance


# create all tables before we run this by going to all the model classes and creating the tables
# db is instantiated before this is called
@app.before_first_request
def create_tables():
    db.create_all()

'''
We create a JWT instance passing as parameters the ‘app’ itself, the “authentication” method and the “identity” method. 
‘JWT’ from ‘flask_jwt’ and ‘authenticate’ and ‘identity’ from ‘security’ were imported for this.
'''
jwt = JWT(app, authenticate, identity)

# define the resources used the and urls to call those resources
api.add_resource(Session, '/session/<string:name>')
api.add_resource(player_resource.Player, '/player/<string:name>')
api.add_resource(SessionList, '/sessions')
api.add_resource(player_resource.PlayerList, '/players')
api.add_resource(Command, '/command/<string:playername>/<string:command>')

api.add_resource(UserRegister, '/register')

socketio = SocketIO(app)


@socketio.on('message')
def handleMessage(msg):
    print('AAAAAAAAAAAAAAAAAH')
    print('Message: ' + msg)
    send(msg, namespace='private')


# makes sure the app is only run once
if __name__ == '__main__':
    from db import db
    db.init_app(app)
    socketio.run(app, port=5000, debug=True)
