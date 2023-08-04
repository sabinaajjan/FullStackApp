from flask import Flask, request, jsonify, Response
from flask_restful import reqparse, Api, Resource
from flask_restful.inputs import boolean
from flask_cors import CORS
import sys
import os
import random
import requests
from typing import Dict, Tuple, Optional, Any, List, Callable, NamedTuple
import asyncio
import mysql.connector
from mysql.connector import Error
import re
from secrets import token_hex
import datetime
import os
import decimal
import flask.json
import datetime

import pprint
# Load environment variables from `.env`
with open('.env', 'r') as f:
    env_vars = dict(
        tuple(line.split('='))
        for line in f.readlines()
        if not line.startswith('#')
    )
os.environ.update(env_vars)

app = Flask(__name__)

os.environ.update(env_vars)

app = Flask(__name__)

cors = CORS(app)  # allow CORS on all routes
app.config['JSON_SORT_KEYS'] = False
api = Api(app)
# Fix decimal to string issue
class MyJSONEncoder(flask.json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            # Convert decimal instances to strings.
            return str(obj)
        return super(MyJSONEncoder, self).default(obj)
app.json_encoder = MyJSONEncoder
try:
    # Check MySQL Workbench > Database > Connect to Database > Test Connection for the host name, etc.
    connection = mysql.connector.connect(
        host=os.environ['HOST'],
        database=os.environ['DATABASE'],
        user=os.environ['USER'],
        password=os.environ['PASSWORD']
    )
    cursor = connection.cursor(buffered=True)
except mysql.connector.Error as error:
    print('Failed to connect to database: ' + repr(error))


def db_api(procedure: str, http_methods: List[str], inputs: List[Tuple[str, Dict[str, Any]]], get_result: int = 0) -> Callable[[None], Response]:

    """
Parameters:
- procedure: name of the MySQL stored procedure which we will call.
- The URL for the API endpoint is just '/' plus the name of the procedure (e.g., '/login').
- Access to the API will be restricted to certain user types if `procedure` begins with 'ad_', 'mn_', or 'cus_'. In this case, either a 'token' cookie or a `token` request parameter is expected (or both, the `token` request parameter taking precedence). Well actually the cookie thing doesn't work so you should use a token request parameter.
- A procedure named 'login' will create a token for the user and set a cookie for that, and also return that in the response.
- http_methods: HTTP methods, such as ['GET'] (if the operation is just fetching data and doesn't modify the database), or ['POST']
- inputs: request parameters, which will be passed into the stored procedure. These arguments should be in the same order as the SQL stored procedure, but can be called anything you like.
- Example: [('username', {'type': str, 'required': True}), ('balance', {'type': int, 'default': 0})]
- See reqparse (https://flask-restful.readthedocs.io/en/latest/reqparse.html) for documentation on other keys we can have in the dictionary, besides 'type', 'required', 'default', etc.
- When contacting the API, the client can pass these parameters in as query parameters or form body parameters.
- get_result: whether the procedure creates a table named `procedure + '_result'` (e.g., 'login_result'), and if it does, whether it returns one or many rows. If so, we'll make another SELECT query to get that table, after we call the procedure. Then, the response of the API endpoint is the result. Otherwise, the response an empty JSON object [].
0: the procedure does not create a "_result" table. The API endpoint will return an empty list, [].
1: the procedure is expected to create a "_result" table with one result
2: the procedure is expected to create a list of results

    Returns a function that works as a Flask API endpoint.
    """
    @app.route('/' + procedure, methods=http_methods, endpoint=procedure)
    def new_api() -> Response:
        nonlocal inputs
        nonlocal get_result
        parser = reqparse.RequestParser()
        for arg_name, arg_params in inputs:
            parser.add_argument(arg_name, **arg_params)
        try:
            a = parser.parse_args()
        except Exception as e:
            print('Request: ' + repr(request.values.to_dict()))
            print(repr(e))
            return {'error': 'Bad request. Expected request arguments: ' + str(parser.args)}, 400
        print('Request: ' + repr(a))
        try:
            cursor.callproc(procedure, args=tuple(a.values()))
            connection.commit()
            if get_result:
                cursor.execute(f"SELECT * FROM {procedure + '_result'};")
                fields = [col[0] for col in cursor.description]
                result = [dict(zip(fields, row)) for row in cursor.fetchall()]
                if len(result) == 1 and get_result == 1:
                    result = result[0]
                else:
                    result = list(filter(lambda x: x != {}, result))
                # Create and send a token upon successful login
                    response = jsonify(result)
                print(f'Result: {result}')
                return response
            else:
                return jsonify([])

        except ValueError as e:
            message = 'Incorrect parameter types'
            print(message + ' ' + repr(e))
            return {'error': message}, 400
        except mysql.connector.Error as e:
            print(repr(e))
            return {'error': repr(e)}, 400
        except Exception as e:
            message = 'Unknown error: ' + repr(e)
            print(locals())
            return {'error': repr(e)}, 400

    return new_api
date = str; #lambda date: datetime.strptime(d, '%Y-%m-%d').date()  # date input type

# Query #1: add_owner [Screen #1: Add Owner]
# Response: {username: str, userType: str} or [] if no user found
add_owner = db_api('add_owner', ['POST'], [
    ('username', {'type': str, 'required': True}),
    ('first_name', {'type': str, 'required': True}),
    ('last_name', {'type': str, 'required': True}),
    ('address', {'type': str, 'required': True}),
    ('birthdate', {'type': str, 'required': True}),
])

# Query #2: register [Screen #2 Add Employee]
# Response: []
add_employee = db_api('add_employee', ['POST'], [
    ('username', {'type': str, 'required': True}),
    ('first_name', {'type': str, 'required': True}),
    ('last_name', {'type': str, 'required': True}),
    ('address', {'type': str, 'required': True}),
    ('birthdate', {'type': str, 'required': True}),
    ('taxID', {'type': str, 'required': True}),
    ('hired', {'type': str, 'required': True}),
    ('employee_experience', {'type': int, 'required': True}),
    ('salary', {'type': int, 'required': True}),

])

# Query #2: register [Screen #2 Add Employee]
# Response: []
add_ingredient = db_api('add_ingredient', ['POST'], [
    ('barcode', {'type': str, 'required': True}),
    ('iname', {'type': str, 'required': True}),
    ('weight', {'type': int, 'required': True}),

])

def close_connection() -> None:
    connection.close()
    print('MySQL connection closed')


