from flask import Flask
from flask_restful import Api
from flask_jwt import JWT

from security import authenticate, identity
from user_resource import UserRegister
from player_resource import Student, StudentList
from session_resource import School, SchoolList


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
api.add_resource(School, '/school/<string:name>')
api.add_resource(Student, '/student/<string:name>')
api.add_resource(SchoolList, '/schools')
api.add_resource(StudentList, '/students')

api.add_resource(UserRegister, '/register')


# makes sure the app is only run once
if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)
