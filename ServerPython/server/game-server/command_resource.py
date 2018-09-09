from flask_restful import Resource
from player_model import PlayerModel
from command_model import CommandModel
from actions_model import ElementModel

class Command(Resource):

    def get(self, playername, direction):
        player = PlayerModel.find_by_name(playername)
        if player:
            return CommandModel.find_by_player_name(playername).json()
        return {'message': 'Player not found'}, 404

    def post(self, playername, direction):
        command = CommandModel.find_by_player_name(playername)
        if command:
            command.delete_from_db()
            command = CommandModel(direction, playername)
        else:
            command = CommandModel(direction, playername)

        try:
            command.save_to_db()
        except:
            return {'message': 'An error occurred inserting the command.'}, 500

        return command.json(), 201

    def delete(self, player_name):
        command = CommandModel.find_by_player_name(player_name)
        if command:
            command.delete_from_db()

        return {'message': 'Command deleted'}





class CommandsList(Resource):
    def get(self):
        return {'commands': list(map(lambda x: x.json(), CommandModel.query.all()))}
