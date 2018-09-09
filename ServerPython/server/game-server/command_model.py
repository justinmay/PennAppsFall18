from db import db

class CommandModel(db.Model):
    __tablename__ = 'commands'

    id = db.Column(db.Integer, primary_key=True)
    direction = db.Column(db.String(80))


    # connects player_id variable with foreign key player_id
    playername = db.Column(db.String(80), db.ForeignKey('players.name'))

    # create relationship with the other class name (which is SchoolModel)
    # lazy=dynamic means that it will fetch the data when it is called, not before
    player = db.relationship('PlayerModel')

    def __init__(self, direction, playername):
        self.direction = direction
        self.playername = playername

    def json(self):
        return {'command_direction': self.direction,  'player_name': self.playername}

    def update_direction(self, direction):
        self.direction = direction


    @classmethod
    def find_by_command_element(cls, name):
        return cls.query.filter_by(name=name).first()

    @classmethod
    def find_by_player_name(cls, playername):
        return cls.query.filter_by(playername=playername).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
