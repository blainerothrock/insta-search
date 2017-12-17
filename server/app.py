import json

import requests
from flask import Flask, request, redirect

# Instagram client ID and secret from registering in dev portal
IG_CLIENT_ID = "7b867a5f5a9d4b7486e340e3d95bc8e1"
# This should be kept secret in real life, but I am ok with this client getting shut down ;)
IG_CLIENT_SECRET = "b7ed232bc1f5422698bd0f7fde27c6c9"

app = Flask(__name__)


@app.route('/callback')
def callback():
    # get code from request query param
    code = request.args["code"]
    # use code to perform oauth request to get auth token
    auth_resp = requests.post("https://api.instagram.com/oauth/access_token",
                              data={
                                  "client_id": IG_CLIENT_ID,
                                  "client_secret": IG_CLIENT_SECRET,
                                  "grant_type": "authorization_code",
                                  "code": code,
                                  "redirect_uri": request.base_url
                              })
    # assuming success we grab the access token (this does not handle errors properly!)
    token = json.loads(auth_resp.text)["access_token"]
    user = json.loads(auth_resp.text)["user"]
    print(user)
    # redirect back to the app with the token as a query param
    redirect_url = "instatag://?token=" + str(token)
    print("Redirecting to " + redirect_url)
    return redirect(redirect_url)


if __name__ == '__main__':
    app.run(host="0.0.0.0")
