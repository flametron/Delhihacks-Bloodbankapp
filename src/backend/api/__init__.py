from flask import Flask, Blueprint, request
from flask_bcrypt import Bcrypt
from flask_cors import CORS

from api.models import db
from api.email import mail

import os

app = Flask(__name__)
CORS(app)

app.config.from_object(
    os.environ.get("APP_SETTINGS", default="api.config.settings.DevelopmentConfig")
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)  # for initializing refactored cyclic imports
bcrypt = Bcrypt(app)
mail.init_app(app)  # for initializing refactored cyclic imports

from api.routes import api

app.register_blueprint(api, url_prefix="/api")
