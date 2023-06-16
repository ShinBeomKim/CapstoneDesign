from flask import Flask, request, jsonify
import pymysql.cursors

# db에서 해당 학번과 생년월일이 있는 지 체크하는 함수
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

# 예약이 종료되면 실행되는 함수
def end_reservation(locker_number):
    # 데이터베이스 연결 설정
    db = pymysql.connect(
        host='localhost',
        user='sb',
        password='sb203705',
        db='public_lockers',
        charset='utf8mb4'
    )

    try:
        with db.cursor() as cursor:
            # reservations 테이블에서 해당 사물함 예약 삭제
            sql_delete = """
            DELETE FROM reservations
            WHERE locker_number = %s
            """
            cursor.execute(sql_delete, (locker_number,))

            # lockers 테이블에서 해당 사물함의 reserved를 0으로 업데이트
            sql_update = """
            UPDATE lockers
            SET reserved = 0
            WHERE locker_number = %s
            """
            cursor.execute(sql_update, (locker_number,))
        
        db.commit()

    except Exception as e:
        db.rollback()
        print(f"Failed to end reservation: {e}")

    finally:
        db.close()