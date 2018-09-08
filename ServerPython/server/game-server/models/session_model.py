from db import db
from models.player_model import PlayerModel

class SessionModel(db.Model):
    __tablename__ = 'sessions'

    id = db.Column(db.Integer, primary_key=True)

    # connects player_id variable with foreign key player_id
    player_name = db.Column(db.String(80), db.ForeignKey('players.name'))

    # create relationship with the other class name (which is SchoolModel)
    # lazy=dynamic means that it will fetch the data when it is called, not before
    session = db.relationship('PlayerModel')  #if lazy='dynamic', students is a query builder
    health = db.Column(db.Integer)

    def __init__(self, player_name, health=100):
        self.player_name = player_name
        self.health = health

    def json(self):
        return {'player': self.player_name, 'health': self.health}

    def update_health(self, health):
        self.health = health

    @classmethod
    def find_by_name(cls, name):
        return PlayerModel.find_by_name(name)

    @classmethod
    def find_by_id(cls, session_id):
        return cls.query.filter_by(id=session_id).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
