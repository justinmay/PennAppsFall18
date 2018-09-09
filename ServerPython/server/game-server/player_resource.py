from flask_restful import Resource
from player_model import PlayerModel

from flask_socketio import SocketIO

class Player(Resource):

    def get(self, name):
        player = PlayerModel.find_by_name(name)
        if player:
            return player.json()
        return {'message': 'Player not found'}, 404

    def post(self, name):

        import app

        SocketIO.emit(app.socketio, event='message', data='hello data!')
        SocketIO.emit(app.socketio, event='message', data='private data!')

        #app.handleMessage('message!!')

        if PlayerModel.find_by_name(name):
            return {'message': "A Player with name '{}' already exists.".format(name)}, 400


        Player = PlayerModel(name) # (name, data['name'])

        try:
            Player.save_to_db()
        except:
            return {'message': 'An error ocurred inserting the Player.'}, 500

        return Player.json(), 201

    def delete(self, name):
        player = PlayerModel.find_by_name(name)
        if player:
            player.delete_from_db()

        return {'message': 'Player deleted'}

class PlayerList(Resource):
    def get(self):
        return {'students': list(map(lambda x: x.json(), PlayerModel.query.all()))}