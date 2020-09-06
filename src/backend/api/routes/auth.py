from flask import request, make_response, jsonify, url_for
import uuid, jwt, datetime
from functools import wraps

from api import app, bcrypt
from api.routes import api
from api.models import db
from api.models.users import User


# checking whether loged-in or not based on that info, data is provided
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        if "x-access-token" in request.headers:
            token = request.headers["x-access-token"]

        if not token:
            return jsonify({"message": "Token is missing!!"}), 401

        try:
            data = jwt.decode(token, app.config["SECRET_KEY"])
            current_user = User.query.filter_by(public_id=data["public_id"]).first()
        except:
            return jsonify({"message": "Token is invalid!!"}), 401

        return f(current_user, *args, **kwargs)

    return decorated


# signup route
@api.route("/register", methods=["POST"])
def signup():
    """
    User Signup (/register)

    POST DATA:
    firstName : First Name of the User
    lastName : Last Name of the User
    email : Email of the User
    password : Password of the user
    blood : blood group
    dob : DD/MM/YYYY
    weight : weight
    lat : float
    long : float
    phone : 10digit

    Returns:
        201 -- success
        202 -- fail (user already exists)
        401 -- fail (unknown error)
    """
    data = request.get_json(silent=True)

    fname, lname, email, password, blood, dob, weight, lat, lon, phone, sex = (
        data.get("firstName"),
        data.get("lastName"),
        data.get("email"),
        data.get("password"),
        data.get("blood"),
        data.get("dob"),
        data.get("weight"),
        data.get("lat"),
        data.get("long"),
        data.get("phone"),
        data.get("sex"),
    )

    user = User.query.filter_by(email=email).first()

    if not user:
        try:
            # database ORM object
            user = User(
                first_name=fname,
                last_name=lname,
                email=email,
                phone=phone,
                password=password,
                location=(lat, lon),
                bloodgroup=blood,
                dob=dob,
                weight=weight,
                sex=sex,
            )
            # insert user
            db.session.add(user)
            db.session.commit()

            responseObject = {
                "status": "success",
                "message": "Successfully registered.",
            }

            return make_response(jsonify(responseObject), 201)
        except Exception:
            responseObject = {
                "satus": "fail",
                "message": "Some error occured. Please try again.",
            }

            return make_response(jsonify(responseObject), 401)
    else:
        responseObject = {
            "status": "fail",
            "message": "User already exists. Please Log in.",
        }

        return make_response(jsonify(responseObject), 202)


@api.route("/login", methods=["POST"])
def login():
    """Login
    POST Data:
    email : user email
    password : new password of the user
    Returns:
        201 -- success
        401 -- fail (either email or password is incorrect)
        402 -- fail (user not confirmed)
        403 -- forbidden (user banned)
    """
    auth = request.get_json(silent=True)

    if not auth or not auth.get("email") or not auth.get("password"):
        return make_response("Could not verify", 401)

    user = User.query.filter_by(email=auth.get("email")).first()

    if not user:
        return make_response("Could not verify", 401)

    if bcrypt.check_password_hash(user.password, auth.get("password")):
        if not user.confirmed:
            return make_response(
                jsonify({"status": "fail", "message": "Confirm your email!!"}), 402
            )
        if user.BANNED:
            return make_response({"status": "fail", "message": "USER BANNED!!"}, 403)

        token = jwt.encode(
            {
                "public_id": user.public_id,
                "name": user.first_name,
                "email": user.email,
                "exp": datetime.datetime.utcnow() + datetime.timedelta(days=1),
            },
            app.config["SECRET_KEY"],
        )

        return make_response({"token": token.decode("UTF-8")}, 201)

    return make_response("Could not verify", 401)