from flask import Flask, render_template, jsonify
from system_status import get_uptime, get_status

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/status")
def status():
    return jsonify({
        "connection": get_status(),
        "uptime": get_uptime()
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
