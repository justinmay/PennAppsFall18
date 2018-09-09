from flask_restful import Resource, reqparse  # reqparse in order to parse the body of the request
from user_model import UserModel

class UserRegister(Resource):

    # parser can get the data from the body of the request instead of the url
    parser = reqparse.RequestParser()
    parser.add_argument('username',
        type=str,
        required=True,
        help="This field cannot be left blank."
    )
    parser.add_argument('password',
        type=str,
        required=True,
        help="This field cannot be left blank."
    )

    def post(self):
        # parse input data and store it in data
        data = UserRegister.parser.parse_args()

        # check if the username already exists, if it does return a 400 (Bad Request) message
        if UserModel.find_by_username(data['username']):
            return {"message": "User already exists"}, 400

        # create a new UserModel and save it to the DB
        user = UserModel(data['username'], data['password'])
        user.save_to_db()

        # return 201 message ("Created")
        return {"message": "User created successfully."}, 201
