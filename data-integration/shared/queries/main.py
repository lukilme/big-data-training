from pyhive import hive

conn = hive.Connection(host='localhost', port=10000, username='hive')
cursor = conn.cursor()

cursor.execute('SELECT * FROM vendas')

for row in cursor.fetchall():
    print(row)