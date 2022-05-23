from user import mygensalt
import requests
from passlib.hash import sha256_crypt

BASE = "http://127.0.0.1:5000/"

# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket a", "ticket_status": "New", "is_sprint": 0})
# print(response.json())
# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket b", "ticket_status": "In Progress", "is_sprint": 0})
# print(response.json())
# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket c", "ticket_status": "Finished", "is_sprint": 0})
# print(response.json())
# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket d", "ticket_status": "New", "is_sprint": 1})
# print(response.json())
# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket e", "ticket_status": "In Progress", "is_sprint": 1})
# print(response.json())
# response = requests.put(BASE + "ticket/0", {"ticket_title": "ticket f", "ticket_status": "Finished", "is_sprint": 1})
# print(response.json())
# input()

#response = requests.patch(BASE + "ticket/1", {"ticket_status": "New"})

#response = requests.get(BASE + "ticket/0", {"is_sprint": 0})
#print(response.json())

#response = requests.get(BASE + "ticketlist", {"count": 1})
#print(response.json())

#response = requests.post(BASE + 'user', {"user_login": "admin", "user_password": "admin" })
#print(response.json())