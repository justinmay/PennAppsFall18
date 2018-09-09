from flask_restful import Resource
from session_model import SessionModel
from player_model import PlayerModel

class Session(Resource):
    def get(self, name):
        session = SessionModel.find_by_name(name)
        if session:
            return session.json()
        return {'message': 'Session not found'}, 404


    def put(self,name, health=100):
        player = PlayerModel.find_by_name(name)
        if not player:
            return {'message': 'No corresponding player with name'}, 500

        # if session with name does not exist
        session = SessionModel.find_by_name(name)
        if not session:
            return {'message': 'An error occurred while updating the session'}, 500
        else:  # if session exists, update the health
            session.update_health(health)

    def post(self, name):
        player = PlayerModel.find_by_name(name)
        if not player:
            return {'message': 'No corresponding player with name'}, 500


        session = SessionModel(name)
        try:
            session.save_to_db()
        except:
            return {'message': 'An error occurred while creating the Session'}, 500

        return Session.json(), 201

    def delete(self, name):
        session = SessionModel.find_by_name(name)
        if session:
            session.delete_from_db()

        return {'message': 'Session deleted'}

class SessionList(Resource):
    def get(self):
        return {'sessions': list(map(lambda x: x.json(), SessionModel.query.all()))}
