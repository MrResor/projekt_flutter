from sqlalchemy.sql.expression import false
from dbconfig import db
from flask_restful import Resource, marshal_with, fields, reqparse, abort
from sqlalchemy import func
from passlib.hash import sha256_crypt
import secrets

def mygensalt(length):
    ALPHABET = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    salt = []
    for i in range (length):
        salt.append(secrets.choice(ALPHABET))
    return "".join(salt)

User_fields = {
    'user_id': fields.Integer,
    'user_login': fields.String,
    'user_hash': fields.String,
    'user_salt': fields.String,
    'last_modification': fields.DateTime,
    'creation_date': fields.DateTime
}

user_get_args = reqparse.RequestParser()

user_post_args = reqparse.RequestParser()
user_post_args.add_argument("user_login", type = str, \
    help = "User login is  missing!", required = True)
user_post_args.add_argument("user_password", type = str, \
    help = "User login is  missing!", required = True)

class User_table(db.Model):
    user_id = db.Column(db.Integer, primary_key = True, \
        autoincrement = True, nullable = False)
    user_login = db.Column(db.String(25), nullable = False, unique = True)
    user_hash = db.Column(db.String(43), nullable = False)
    user_salt = db.Column(db.String(16), nullable = False)
    last_modification = db.Column(db.DateTime(timezone = True), \
       default = func.now(), onupdate = func.now(), nullable = False)
    creation_date = db.Column(db.DateTime(timezone = True), \
        default = func.now(), nullable = False)

    def __repr__(self):
        return f"User(id = {self.user_id}, \
            login = {self.user_login}, last updated = {self.last_modification},\
            created = {self.creation_date})"

class User(Resource):
    @marshal_with(User_fields)
    def get(self):
        return ''

    @marshal_with(User_fields)
    def post(self):
        args = user_post_args.parse_args()
        salt = mygensalt(16)
        hash = sha256_crypt.encrypt(args['user_password'], salt = salt, rounds = 535000)
        user = User_table(user_login = args['user_login'], user_salt = salt, user_hash = hash[34:])
        db.session.add(user)
        db.session.commit()
        return user, 201
