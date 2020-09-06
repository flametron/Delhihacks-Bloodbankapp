## imports
import requests
import json

# Driver Function
def withinRange(requestLocation, donorLocation, radius, API_KEY):
    lat1 = requestLocation[0]
    lon1 = requestLocation[1]

    lat2 = donorLocation[0]
    lon2 = donorLocation[1]

    # URL
    _url_ = (
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
        + str(lat1)
        + ","
        + str(lon1)
        + "&destinations="
        + str(lat2)
        + ","
        + str(lon2)
        + "&mode=driving&language=en-EN&key="
        + API_KEY
    )
    data = json.loads(requests.get(_url_).text)
    # dest = data["destination_addresses"][0]                            Destination Name
    # orig = data["origin_addresses"][0]                                 Origin Name
    dist = data["rows"][0]["elements"][0]["distance"]["value"] / 1000  # In Km
    time = data["rows"][0]["elements"][0]["duration"]["value"]  # In Secs
    # Consider the radius as float
    if dist <= radius:
        return True, time
    else:
        return False, None
    ## returns True or False whether the user is in range or not


# Test Case
if __name__ == "__main__":
    print(withinRange((22.8637511, 88.3669716), (22.9531, 88.3759), 12.00))
