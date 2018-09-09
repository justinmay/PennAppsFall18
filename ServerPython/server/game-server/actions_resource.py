from flask_restful import Resource
from player_model import PlayerModel
from command_model import CommandModel
from actions_model import ElementModel

class Action(Resource):

    def get(self, player_name):
        player = PlayerModel.find_by_name(player_name)
        if player:
            element = ElementModel.find_by_player_name(player_name)
            if element:
                retVal = element.json() + CommandModel.find_by_player_name(player_name).json()
                ElementModel.delete_from_db(element)
                return retVal
        return {'message': 'No action ready'}, 404

    def post(self, player_name, element_name):
        element = ElementModel.find_by_player_name(player_name)
        if element:
            ElementModel.delete_from_db(element)
            return {'message': 'Lingering element in DB'}, 500
        else:
            element = ElementModel(element_name, player_name)

        try:
            element.save_to_db()
        except:
            return {'message': 'An error ocurred inserting the element.'}, 500

        return element.json(), 201

    def delete(self, player_name):
        element = ElementModel.find_by_player_name(player_name)
        if element:
            element.delete_from_db()

        return {'message': 'Action deleted'}