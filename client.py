from flask import Flask, render_template
import pymysql

app = Flask(__name__)


class Database:
    def __init__(self):
        host = "192.168.31.120"
        user = "test"
        password = "password"
        db = "users"

        self.con = pymysql.connect(host=host, user=user, password=password, db=db, cursorclass=pymysql.cursors.
                                   DictCursor)
        self.cur = self.con.cursor()

    def list_users(self):
        self.cur.execute("SELECT first_name, last_name, gender FROM users LIMIT 50")
        result = self.cur.fetchall()

        return result

@app.route('/')
def users():

    def db_query():
        db = Database()
        emps = db.list_users()

        return emps

    res = db_query()

    return render_template('users.html', result=res, content_type='application/json')

