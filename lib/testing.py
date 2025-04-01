import sqlite3
conn = sqlite3.connect('example.db')  # Replace 'example.db' with your database name
cursor = conn.cursor()  # Create a cursor to interact with the database

cursor.execute('''
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER
)
''')
conn.commit()  # Save changes
cursor.execute('INSERT INTO users (name, age) VALUES (?, ?)', ('Alice', 25))
conn.commit()
cursor.execute('SELECT * FROM users')
rows = cursor.fetchall()  # Get all rows
for row in rows:
    print(row)

