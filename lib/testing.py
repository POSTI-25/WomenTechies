# import sqlite3
# import threading
# conn = sqlite3.connect('example.db')  # Replace 'example.db' with your database name
# cursor = conn.cursor()  # Create a cursor to interact with the database

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS users (
#     id INTEGER PRIMARY KEY,
#     name TEXT,
#     age INTEGER
# )
# ''')
# conn.commit()  # Save changes
# cursor.execute('INSERT INTO users (name, age) VALUES (?, ?)', ('Alice', 25))
# conn.commit()
# cursor.execute('SELECT * FROM users')
# rows = cursor.fetchall()  # Get all rows

# def get_info(name ,age):
#     cursor.execute('INSERT INTO users (name, age) VALUES (?, ?)', (name, age))
#     conn.commit()
# def displayTab():
#     for row in rows:
#         print(row)
import sqlite3
import threading

DATABASE = 'users.db'  # Replace with your actual SQLite database file

# Helper function to create and return a database connection
def create_connection():
    try:
        conn = sqlite3.connect(DATABASE, check_same_thread=False)  # Allow connections from different threads
        conn.row_factory = sqlite3.Row  # To access rows as dictionary-like objects
        return conn
    except sqlite3.Error as e:
        print(f"Error creating connection: {e}")
        return None

# Create users table if it doesn't exist
def create_table():
    conn = create_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER,
            long REAL,
            lat REAL
        )
        ''')
        conn.commit()
        conn.close()

# Function to insert user data into the database
def insert_user(name, age ,long , lat):
    conn = create_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('INSERT INTO users (name, age,long,lat) VALUES (?, ? ,? ,?)', (name, age ,long , lat))
        conn.commit()
        conn.close()

# Function to retrieve all users from the database
def get_all_users():
    conn = create_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users')
        rows = cursor.fetchall()
        conn.close()
        return rows
    else:
        return []

# Function to display users
def display_users():
    users = get_all_users()
    for user in users:
        print(f"ID: {user['id']}, Name: {user['name']}, Age: {user['age']}, Location: ({user['long']}, {user['lat']})")

# Call create_table() to ensure table exists when the script runs
create_table()

# Example usage (This part would be used to test the functions, not needed in the backend):
# insert_user('Alice', 25)
# display_users()  # Call this to see the current users in the database


