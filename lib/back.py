from flask import Flask, request, jsonify
import sqlite3
import threading
import testing

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
        return jsonify({"message": "User data saved successfully!",'id':id }), 200

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

@app.route('/get_locations', methods=['GET'])
def get_locations():
    return jsonify({"locations": location_data}), 200





@app.route('/add_driver', methods=['POST'])
def add_driver():
    try:
        # Get data from request (should be a JSON object)
        data = request.get_json()

        name = data.get('name')
        age = data.get('age')
        autonumber = data.get('autonumber')
        lat = data.get('lat')
        long = data.get('long')
        print("working_1")
        # testing.insert_user(name , age, gender)
        # testing.display_users()
        # Validate input
        if not name or not age:
            return jsonify({"error": "Both name and age are required"}), 400

        testing.insert_driver(name, age, autonumber,lat,long)
        print("working_2")
        testing.display_driver()
        # Store the user data in memory (you can store it in a file/database)
        driver_data.append({'name': name, 'age': age, 'autonumber':autonumber,'lat':lat,'long':long})
        
        # Return success message
        return jsonify({"message": "User data saved successfully!" , 'id':id}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get_driver', methods=['GET'])
def get_driver():
    return jsonify({"driver": driver_data}), 200

if __name__ == '__main__':
    # Initialize database
    app.run(debug=True)