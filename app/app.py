# app.py
from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    name = os.environ.get("NAME", "World")
    return f"Hello, {name}!! This is a new update!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

