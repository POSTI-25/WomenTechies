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

DATABASE_USER = 'user.db'  # Replace with your actual SQLite database file
DATABASE_DRIVER = 'drivers.db'

# Helper function to create and return a database connection
def create_connection_user():
    try:
        conn = sqlite3.connect(DATABASE_USER, check_same_thread=False)  # Allow connections from different threads
        conn.row_factory = sqlite3.Row  # To access rows as dictionary-like objects
        return conn
    except sqlite3.Error as e:
        print(f"Error creating connection: {e}")
        return None
    
def create_connection_driver():
    try:
        conn = sqlite3.connect(DATABASE_DRIVER, check_same_thread=False)  # Allow connections from different threads
        conn.row_factory = sqlite3.Row  # To access rows as dictionary-like objects
        return conn
    except sqlite3.Error as e:
        print(f"Error creating connection: {e}")
        return None

# Create users table if it doesn't exist
def create_table_user():
    conn = create_connection_user()
    if conn:
        cursor = conn.cursor()
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER,
            long REAL,
            lat REAL,
            gender TEXT          
        )
        ''')
        conn.commit()
        conn.close()

def create_table_driver():
    conn = create_connection_driver()
    if conn:
        cursor = conn.cursor()
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS driver (
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER,
            autonumber INT          
        )
        ''')
        conn.commit()
        conn.close()

# Function to insert user data into the database
def insert_user(name, age ,long , lat,gender):
    conn = create_connection_user()
    if conn:
        cursor = conn.cursor()
        cursor.execute('INSERT INTO users (name, age, gender) VALUES (?, ?, ?, ?, ?)', (name, age,long ,lat,gender))

        conn.commit()
        conn.close()

def insert_driver(name, age, autonumber):
    conn = create_connection_driver()
    if conn:
        cursor = conn.cursor()
        cursor.execute('INSERT INTO driver (name, age, autonumber) VALUES (?, ?, ?)', (name, age, autonumber))

        conn.commit()
        conn.close()

# Function to retrieve all users from the database
def get_all_users():
    conn = create_connection_user()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users')
        rows = cursor.fetchall()
        conn.close()
        return rows
    else:
        return []
    
def get_driver():
    conn = create_connection_driver()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM driver')
        rows = cursor.fetchall()
        conn.close()
        return rows
    else:
        return []

# Function to display users
def display_users():
    users = get_all_users()
    for user in users:
        print(f"ID: {user['id']}, Name: {user['name']}, Age: {user['age']}, Location: ({user['long']}, {user['lat']}), Gender: {user['gender']}")

def display_driver():
    driver = get_driver()
    for drivers in driver:
        print(f"ID: {drivers['id']}, Name: {drivers['name']}, Age: {drivers['age']}, AutoNumber: {drivers['autonumber']}")

# Call create_table() to ensure table exists when the script runs
create_table_user()
create_table_driver()

# Example usage (This part would be used to test the functions, not needed in the backend):
# insert_user('Alice', 25)
# display_users()  # Call this to see the current users in the database

# chnges


