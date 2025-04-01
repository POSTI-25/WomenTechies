import firebase_admin
from firebase_admin import credentials, db
import os
# Path to your service account key file (update this with the correct path)
cred = credentials.Certificate('C:\GitProjects\womentechies-83a98-firebase-adminsdk-fbsvc-974067c166.json')

# Initialize Firebase app with the correct database URL
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://womentechies-83a98-default-rtdb.asia-southeast1.firebasedatabase.app/'  # Replace <your-project-id> with your actual Firebase project ID
})

# Reference the database path
ref = db.reference('users')

# Add data to the 'users' node
ref.push({
    'name': 'Alice',
    'email': 'alice@example.com',
    'age': 25
})
ref.push({
    'name': 'Bob',
    'email':'bob@example.com',
    'age': 30
})

print("Data successfully added to Firebase Realtime Database!")
