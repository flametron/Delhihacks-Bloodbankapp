from flask import request, make_response, jsonify, url_for
import uuid, jwt, datetime
from functools import wraps

from api import app
from api.routes import api
from api.models import db
from api.models.users import User
from api.models.blood import Blood
from api.utils.blood import withinRange


@api.route("/find", methods=["POST"])
def find_blood():
    """
    Find blood (/find)

    POST
        - blood: str
        - lat: float
        - lon: float
        - radius: int

    RESPONSE:
    {
        "message": "success",
        "users": [
            {
                public_id: str,
                firstName: str,
                lastName: str,
                email: str,
                phone: str,
                location: (lat: float, lon: float),
                dob: DD/MM/YYYY,
                weight: int
                ETA: time in sec
            },
            {
                ...
            },
        ]
    }
    """

    usersList = list()
    data = request.get_json(silent=True)

    bloodgroup, lat, lon, radius = (
        data.get("blood"),
        data.get("lat"),
        data.get("lon"),
        int(data.get("radius", 30)),
    )

    users = User.query.filter_by(bloodgroup=bloodgroup).all()

    for user in users:
        requestLocation = (lat, lon)
        donorLocation = (user.lat, user.lon)
        isTrue, time = withinRange(
            requestLocation, donorLocation, radius, app.config["MAP_API_KEY"]
        )
        if isTrue:
            user_json = user.serialize
            user_json["ETA"] = time
            usersList.append(user_json)

    return make_response(
        jsonify(
            {
                "message": "success",
                "users": usersList,
            }
        ),
        200,
    )


@api.route("/tickets", methods=["GET", "POST"])
def create_ticket():
    """
    List Tickets (/tickets)
    GET

    Response
    {
        "status" : "success",
        "tickets" : [
            {
                public_id: str,
                firstName: str,
                lastName: str,
                phone: str,
                location: (latitude, longitude),
                blood: str,
                sex: str,
                age: str,
                created: str
            }
        ]
    }

    POST
        - firstName: str
        - lastName: str,
        - phone: str,
        - lat: float,
        - long: float
        - blood: str,
        - sex: str,
        - age: str,
    """

    if request.method == "GET":
        response = list()
        tickets = Blood.query.order_by(Blood.age).all()

        for ticket in tickets:
            response.append(ticket.serialize)

        return make_response(jsonify({"status": "success", "tickets": response}), 200)

    elif request.method == "POST":
        data = request.get_json(silent=True)
        firstName, lastName, phone, lat, lon, blood, sex, age = (
            data.get("firstName"),
            data.get("lastName"),
            data.get("phone"),
            data.get("lat"),
            data.get("long"),
            data.get("blood"),
            data.get("sex"),
            data.get("age"),
        )

        ticket = Blood(firstName, lastName, phone, (lat, lon), blood, sex, age)

        # insert user
        db.session.add(ticket)
        db.session.commit()

        return make_response(
            jsonify({"status": "success", "message": "ticket system"}), 200
        )
