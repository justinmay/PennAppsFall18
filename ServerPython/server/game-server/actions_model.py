from db import db

class ActionModel(db.Model):
    __tablename__ = 'actions'

    id = db.Column(db.Integer, primary_key=True)
    element = db.Column(db.String(80))


    # connects player_id variable with foreign key player_id
    playername = db.Column(db.String(80), db.ForeignKey('players.name'))

    # create relationship with the other class name (which is SchoolModel)
    # lazy=dynamic means that it will fetch the data when it is called, not before
    player = db.relationship('PlayerModel')

    def __init__(self, element, playername):
        self.element = element
        self.playername = playername

    def json(self):
        return {'command_element': self.element,  'player_name': self.playername}

    def update_command(self, command_name):
        self.name = command_name


    @classmethod
    def find_by_command_element(cls, name):
        return cls.query.filter_by(element=name).first()

    def find_by_player_name(cls, name):
        return cls.query.filter_by(player_name=name)

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
