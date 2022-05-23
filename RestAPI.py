from dbconfig import db, api, app
from ticket import Ticket, TicketCount, TicketList
from user import User
from session import Session

#db.create_all()

api.add_resource(Ticket, "/ticket/<int:ticket_number>")
api.add_resource(TicketList, "/ticket/ticketlist")
api.add_resource(User, "/user")
api.add_resource(Session, "/session")
api.add_resource(TicketCount, "/ticket/ticketcount")

if __name__ == "__main__":
    app.run(debug = True)