from flask import Flask, request, jsonify
import pymysql.cursors

# db에서 해당 학번과 생년월이이 있는 지 체크
def check_credentials(student_number, birth_date):
    connection = pymysql.connect(host='127.0.0.1',
                                 user='sb',
                                 password='sb203705',
                                 db='public_lockers',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)

    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM users WHERE student_number = %s AND birth_date = %s"
            cursor.execute(sql, (student_number, birth_date))
            result = cursor.fetchone()
            return result is not None
    finally:
        connection.close()
