from models.user_model import UserModel
# this class handles the flask-jwt

# returns a access-token for the user if it is found in the database (does not return the user object itself)
def authenticate(username, password):
    user = UserModel.find_by_username(username)
    if user and user.password == password:
        return user

# called with the #jwt_required
# return the appropriate user for the access token
def identity(payload):
    user_id = payload['identity']
    return UserModel.find_by_id(user_id)
