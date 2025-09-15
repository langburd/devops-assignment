#!/usr/bin/env python3

"""Example echo server application prepared for the devops-assignment."""

import os
import re
import socket

import geocoder
from flask import Flask, jsonify, render_template, request

app = Flask(__name__, template_folder="web")

# Get data from the environment variables
app_environment = os.environ.get("APP_ENVIRONMENT", "undefined")
app_version = os.environ.get("APP_VERSION", "v1.0.0")
app_hostname = socket.gethostname()


def render():
    """Function rendering the index.html file."""
    return render_template(
        "index.html",
        app_environment=app_environment,
        app_version=app_version,
        app_hostname=app_hostname,
    )


@app.route("/")
def serve_root():
    """Function serving the index.html file."""

    return render()


@app.route("/index.html")
def serve_index():
    """Function serving the index.html file."""

    return render()


@app.route("/json")
def echo():
    """
    Main function returning the given echo string and geo location of the user.
    """
    echo_string = {
        "_app_environment": app_environment,
        "_app_version": app_version,
        "_app_repository": "https://github.com/langburd/devops-assignment",
    }

    # Get the client IP from the request
    if request.headers.getlist("X-Forwarded-For"):
        client_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        client_ip = request.remote_addr

    # Clean the client IP from the port number
    if client_ip:
        clean_client_ip = re.findall(r"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", client_ip)
    else:
        clean_client_ip = []

    # Get the geo location data from the client IP
    if clean_client_ip:
        geo_location_data = geocoder.ip(clean_client_ip[0])
    else:
        # Fallback to empty geocoder data if no valid IP found
        geo_location_data = geocoder.ip("127.0.0.1")

    # Merge two dictionaries
    response_data = echo_string | geo_location_data.json

    return jsonify(response_data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
