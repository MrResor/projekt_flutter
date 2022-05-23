from flask_restful import Resource, marshal_with, reqparse, abort, fields
from user import User_fields, User_table, mygensalt
from dbconfig import db
from sqlalchemy import func
from passlib.hash import sha256_crypt
from datetime import datetime, timedelta

session_fields = {

    'user_login': fields.String,
    'user_password': fields.String,
    'user_id': fields.Integer,
    'token': fields.String
}

session_post_args = reqparse.RequestParser()
session_post_args.add_argument("user_login", type = str, \
    help = "User login is  missing!", required = True)
session_post_args.add_argument("user_password", type = str, \
    help = "User login is  missing!", required = True)
session_post_args.add_argument("user_id", type = int)
session_post_args.add_argument("token", type = str)

class User_Session_table(db.Model):

    User_session_id = db.Column(db.String(43), nullable = False, primary_key = True)
    User_session_owner = db.Column(db.Integer, nullable = False)
    User_last_modification = db.Column(db.DateTime(timezone = True), default = datetime.now() + timedelta(hours=1), nullable = False)

    def __repr__(self):

        return f"Session(number = {self.User_session_id}, \
            owner = {self.User_session_owner}, timeout = {self.User_last_modification})"

class Session(Resource):
    
    @marshal_with(session_fields)
    def post(self):

        args = session_post_args.parse_args()
        if args['user_login'] == "" and args["user_password"] == "":

            abort(403, error_message = "User Login and password are missing!")

        if args['user_login'] == "":

            abort(403, error_message = "User Login is missing!")

        if args['user_password'] == "":

            abort(403, error_message = "User password is missing!")

        user = User_table.query.filter_by(user_login = args['user_login']).one_or_none()
        if user is None:

            abort(403, error_message = "User Login or password is incorrect!")
        
        hash = "$5$rounds=535000$" + user.user_salt + "$" + user.user_hash
        if not sha256_crypt.verify(args['user_password'], hash):

            abort(403, error_message = "User Login or password is incorrect!")

        #code for session creation here!
        token = sha256_crypt.encrypt(mygensalt(16), salt = mygensalt(16), rounds = 535000)
        session =  User_Session_table(User_session_id = token[34:], User_session_owner = user.user_id)
        db.session.add(session)
        db.session.commit()
        return {"user_id":user.user_id, "token":token}, 200

    @marshal_with(session_fields)
    def delete(self):
        #code for session deletion here!
        return
