from email import message
import logging
import json
from unicodedata import decimal

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    data = req.get_json()
    variable = data["variable"]
    params = data["parameters"]
    result = 0

    if variable == "distance":
        velocity = params["velocity"]
        time = params["time"]
        result = calculate_distance(velocity, time)

    if variable == "velocity":
        distance = params["distance"]
        time = params["time"]
        result = calculate_velocity(distance, time)

    if variable == "time":
        velocity = params["velocity"]
        distance = params["distance"]
        result = calculate_time(velocity, distance)
        
    return func.HttpResponse(json.dumps({
            "code": 200,
            "message": "Executed successfully",
            "data": result
        }),
        mimetype = "application/json",
        status_code=200
    )

def calculate_distance(velocity: decimal, time: decimal):
    return velocity*time

def calculate_velocity(distance: decimal, time: decimal):
    return distance / time

def calculate_time(velocity: decimal, distance: decimal):
    return distance / velocity
