from flask_restful import Resource
from flask_jwt import jwt_required
from models.player_model import PlayerModel
from models.command_model import CommandModel

class Command(Resource):

    def get(self, player_name):
        player = PlayerModel.find_by_name(player_name)
        if player:
            return CommandModel.find_by_player_name(player_name).json()
        return {'message': 'Player not found'}, 404

    def post(self, command_name, player_name):
        command = CommandModel.find_by_player_name(player_name)
        if command:
            command.update_command(command_name)
            return {'message': "Command successfuly added for '{}'.".format(player_name)}, 400
        else:
            command = CommandModel(command_name, player_name)

        try:
            Command.save_to_db()
        except:
            return {'message': 'An error ocurred inserting the command.'}, 500

        return command.json(), 201

    def delete(self, player_name):
        command = CommandModel.find_by_player_name(player_name)
        if command:
            command.delete_from_db()

        return {'message': 'Command deleted'}

class CommandsList(Resource):
    def get(self):
        return {'commands': list(map(lambda x: x.json(), CommandModel.query.all()))}
