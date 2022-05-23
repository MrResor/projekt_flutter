from sqlalchemy.sql.expression import false
from sqlalchemy.exc import NoResultFound
from sqlalchemy.sql.functions import count
from dbconfig import db
from flask_restful import Resource, marshal_with, fields, reqparse, abort
from sqlalchemy import func, asc, desc
from flask import request

Ticket_fields = {
    'ticket_number': fields.Integer,
    'ticket_title': fields.String,
    'ticket_status': fields.String,
    'is_sprint': fields.Integer,
    'last_modification': fields.DateTime,
    'creation_date': fields.DateTime
}

ticket_put_args = reqparse.RequestParser()
ticket_put_args.add_argument("ticket_title", type = str, \
    help = "Ticket title is  missing!", required = True)
ticket_put_args.add_argument("ticket_status", type = str, \
    help = "Ticket status is missing or is incorrect!", required = True)
ticket_put_args.add_argument("is_sprint", type = int, \
    help = "Information if this is a sprint ticket is missing!", required = True)

ticket_getpatch_args = reqparse.RequestParser()
ticket_getpatch_args.add_argument("ticket_status", type = str)
ticket_getpatch_args.add_argument("is_sprint", type = int)
ticket_getpatch_args.add_argument("ticket_title", type = str)
ticket_getpatch_args.add_argument("sort_dir", type = int)
#will have to think the lower part through again
ticket_getpatch_args.add_argument("last_modification", type = str)#yyyy/mm/dd no hour
ticket_getpatch_args.add_argument("creation_date", type = str)#yyyy/mm/dd no hour

class Ticket_table(db.Model):
    ticket_number = db.Column(db.Integer, primary_key = True, \
        autoincrement = True, nullable = False)
    ticket_title = db.Column(db.String(100), nullable = False)
    ticket_status = db.Column(db.Enum("New", "In Progress", "Finished"), nullable = False)
    is_sprint = db.Column(db.Integer, nullable = False)
    last_modification = db.Column(db.DateTime(timezone = True), \
       default = func.now(), onupdate = func.now(), nullable = False)
    creation_date = db.Column(db.DateTime(timezone = True), default = func.now(), nullable = False)

    def __repr__(self):
        return f"Ticket(number = {self.ticket_number}, \
            title = {self.ticket_title}, sprint? = {self.is_sprint}, \
            status = {self.ticket_status}, last updated = {self.last_modification},\
            created = {self.creation_date})"

def catch_errors(wrapped_func):
    def wrapper(*args, **kwargs):
        try:
            return wrapped_func(*args, **kwargs)
        except NoResultFound:
            abort(404, error_message = "Not found")
    return wrapper

class Ticket(Resource):
    @marshal_with(Ticket_fields)
    @catch_errors
    def get(self, ticket_number):
        # import pdb; pdb.set_trace();
        return Ticket_table.query.filter_by(ticket_number = ticket_number).one(), 200

    @marshal_with(Ticket_fields)
    def post(self, ticket_number):
        args = ticket_put_args.parse_args()
        ticket = Ticket_table(ticket_title = args['ticket_title'], \
            ticket_status = args['ticket_status'], is_sprint = args['is_sprint'])
        db.session.add(ticket)
        db.session.commit()
        return ticket, 201

    @marshal_with(Ticket_fields)
    def patch(self, ticket_number):
        ticket = Ticket_table.query.filter_by(ticket_number = ticket_number).first()
        if not ticket:
            abort(404, error_message = "No ticket with given number")
        args = ticket_getpatch_args.parse_args()
        if args["ticket_title"] != None:
            ticket.ticket_title = args["ticket_title"]
        if args["ticket_status"] != None:
            ticket.ticket_status = args["ticket_status"]
        if args["is_sprint"] != None:
            ticket.is_sprint = args["is_sprint"]
        db.session.add(ticket)
        db.session.commit()
        return ticket, 204

    @marshal_with(Ticket_fields)
    def delete(self, ticket_number):
        ticket = Ticket_table.query.filter_by(ticket_number = ticket_number).first()
        if not ticket:
            abort(404, error_message = "No ticket with given number")
        db.session.delete(ticket)
        db.session.commit()
        return ticket, 202

class TicketList(Resource):
    @marshal_with(Ticket_fields)
    def get(self):
        issprint = request.args.get('is_sprint')
        ticketstatus = request.args.get('ticket_status')
        sort = desc if request.args.get("sort_dir") else asc
        args = {'is_sprint': issprint, 'ticket_status': ticketstatus}
        criteria = dict(filter(lambda v: (v[0], v[1]) if v[1] is not None else None, args.items()))
        ticketlist = Ticket_table.query.order_by(sort(Ticket_table.last_modification)).filter_by(**criteria).all()
        return ticketlist, 200

class TicketCount(Resource):
    @marshal_with(Ticket_fields)
    def get(self):
        issprint = request.args.get('is_sprint')
        ticketstatus = request.args.get('ticket_status')
        args = {'is_sprint': issprint, 'ticket_status': ticketstatus}
        criteria = dict(filter(lambda v: (v[0], v[1]) if v[1] is not None else None, args.items()))
        ticketcount = Ticket_table.query.filter_by(**criteria).count()
        return {"ticket_number": ticketcount}, 200
