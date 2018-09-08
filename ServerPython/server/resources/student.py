from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.student import StudentModel

class Student(Resource):
    # set up the parser
    parser = reqparse.RequestParser()
    parser.add_argument('school_id',
        type=int,
        required=True,
        help="Every student needs a school id."
    )

    def get(self, name):
        student = StudentModel.find_by_name(name)
        if student:
            return student.json()
        return {'message': 'Student not found'}, 404

    # tells program we require a JWT access token to run the method, will throw an error otherwise
    @jwt_required()
    def post(self, name):
        if StudentModel.find_by_name(name):
            return {'message': "A student with name '{}' already exists.".format(name)}, 400

        data = Student.parser.parse_args()

        student = StudentModel(name, **data) # (name, data['name'], data['school_id'])

        try:
            student.save_to_db()
        except:
            return {'message': 'An error ocurred inserting the student.'}, 500

        return student.json(), 201

    @jwt_required()
    def delete(self, name):
        student = StudentModel.find_by_name(name)
        if student:
            student.delete_from_db()

        return {'message': 'Student deleted'}

class StudentList(Resource):
    def get(self):
        return {'students': list(map(lambda x: x.json(), StudentModel.query.all()))}
