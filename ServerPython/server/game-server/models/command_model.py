from db import db

class CommandModel(db.Model):
    __tablename__ = 'commands'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))


    # connects player_id variable with foreign key player_id
    player_name = db.Column(db.String(80), db.ForeignKey('players.name'))

    # create relationship with the other class name (which is SchoolModel)
    # lazy=dynamic means that it will fetch the data when it is called, not before
    player = db.relationship('PlayerModel')

    def __init__(self, name, player_name):
        self.name = name
        self.player_name = player_name

    def json(self):
        return {'command_name': self.name, 'player_name': self.player_name}

    def update_command(self, command_name):
        self.name = command_name


    @classmethod
    def find_by_command_name(cls, name):
        return cls.query.filter_by(name=name ).first()

    def find_by_player_name(cls, name):
        return cls.query.filter_by(player_name=name)

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
