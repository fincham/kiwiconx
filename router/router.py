from flask import Flask, request, send_from_directory

app = Flask(__name__)

@app.route('/tty')
def tty_finder():
    return "1"

@app.route('/static/<path:path>')
def send_js(path):
    return send_from_directory('static', path)
