from flask import Flask, request, jsonify
import testing

app = Flask(__name__)

# In-memory storage for simplicity (you can replace this with a database or file)
user_data = []

@app.route('/add_user', methods=['POST'])
def add_user():
    try:
        # Get data from request (should be a JSON object)
        data = request.get_json()

        name = data.get('name')
        age = data.get('age')
        
        testing.insert_user(name , age)
        testing.display_users()
        # Validate input
        if not name or not age:
            return jsonify({"error": "Both name and age are required"}), 400

        # Store the user data in memory (you can store it in a file/database)
        user_data.append({'name': name, 'age': age})

        # Return success message
        return jsonify({"message": "User data saved successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get_users', methods=['GET'])
def get_users():
    return jsonify({"users": user_data}), 200

if __name__ == '__main__':
    app.run(debug=True)
