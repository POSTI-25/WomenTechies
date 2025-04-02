from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import threading
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Database setup
DATABASE = 'autowala.db'

def get_db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

# Active ride requests storage
active_requests = {}

@app.route('/request_ride', methods=['POST'])
def request_ride():
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['user_id', 'driver_id', 'pickup_location']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400
    
    # Store the request
    request_id = f"req_{data['user_id']}_{data['driver_id']}"
    active_requests[request_id] = {
        'user_id': data['user_id'],
        'driver_id': data['driver_id'],
        'pickup_location': data['pickup_location'],
        'status': 'pending',
        'timestamp': datetime.now().isoformat()
    }
    
    return jsonify({
        "request_id": request_id,
        "message": "Ride request sent to driver"
    }), 200

@app.route('/driver/requests/<driver_id>', methods=['GET'])
def get_driver_requests(driver_id):
    driver_requests = {
        k: v for k, v in active_requests.items() 
        if v['driver_id'] == driver_id and v['status'] == 'pending'
    }
    return jsonify(list(driver_requests.values())), 200

@app.route('/respond_ride', methods=['POST'])
def respond_ride():
    data = request.get_json()
    request_id = data.get('request_id')
    
    if request_id not in active_requests:
        return jsonify({"error": "Invalid request ID"}), 404
    
    if data.get('action') == 'accept':
        active_requests[request_id]['status'] = 'accepted'
        # Store in database
        conn = get_db()
        conn.execute('''
            INSERT INTO rides (request_id, user_id, driver_id, status, pickup_location) 
            VALUES (?, ?, ?, ?, ?)
        ''', (
            request_id,
            active_requests[request_id]['user_id'],
            active_requests[request_id]['driver_id'],
            'accepted',
            str(active_requests[request_id]['pickup_location'])
        ))
        conn.commit()
        conn.close()
        
        return jsonify({"message": "Ride accepted"}), 200
    else:
        active_requests[request_id]['status'] = 'rejected'
        return jsonify({"message": "Ride rejected"}), 200

if __name__ == '__main__':
    # Initialize database
    with get_db() as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS rides (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                request_id TEXT UNIQUE,
                user_id TEXT,
                driver_id TEXT,
                status TEXT,
                pickup_location TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
    app.run(host='0.0.0.0', port=5000, debug=True)