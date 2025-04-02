from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import threading
from datetime import datetime

app = Flask(__name__)

# In-memory storage for simplicity (you can replace this with a database or file)
user_data = []
location_data = []  # New list to store location updates
driver_data = []

@app.route('/add_user', methods=['POST'])
def add_user():
    try:
        # Get data from request (should be a JSON object)
        data = request.get_json()

        name = data.get('name')
        age = data.get('age')
        long = data.get('long')
        lat = data.get('lat')
        gender = data.get('gender')
        print("working")
        # testing.insert_user(name, age, long, lat, gender)
        # testing.display_users()

        # Validate input
        if not name or not age:
            return jsonify({"error": "Both name and age are required"}), 400

        id=testing.insert_user(name, age, long,lat,gender)
        testing.display_users()
        # Store the user data in memory (you can store it in a file/database)
        user_data.append({'name': name, 'age': age, 'long': long, 'lat': lat, 'gender':gender})
        
        # Return success message
        return jsonify({"message": "User data saved successfully!",'id':id}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get_users', methods=['GET'])
def get_users():
    return jsonify({"users": user_data}), 200

# New endpoint to receive location data
@app.route('/update_location', methods=['POST'])
def update_location():
    try:
        # Get location data from request (should be a JSON object)
        data = request.get_json()

        #user_id = data.get('user_id')  # You can associate location data with a user
        lat = data.get('lat')
        long = data.get('long')
        print("lat: ",lat,"long: ",long)

        # Validate input
        if not lat or not long:
            return jsonify({"error": "Both latitude and longitude are required"}), 400

        # Append location data to memory (you can store it in a database)
        location_data.append({
            'lat': lat,
            'long': long
        })

        # Return success message
        return jsonify({"message": "Location data received successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

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