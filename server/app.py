import atexit
from datetime import datetime
from flask import Flask, request, jsonify
import pymysql.cursors
import func
from apscheduler.schedulers.background import BackgroundScheduler
from dateutil.parser import parse
import requests
from flask_cors import CORS

# Flask 앱 생성
app = Flask(__name__)
CORS(app, supports_credentials=True)

# APScheduler 생성 및 시작
scheduler = BackgroundScheduler(daemon=True)
scheduler.start()

# Flask 앱이 종료될 때 APScheduler도 함께 종료되도록 설정
atexit.register(lambda: scheduler.shutdown())

# 로그인 요청 들어오면 해당 기능 수행
@app.route('/login', methods=['POST'])
def login():
    if not request.is_json:
        return "Missing JSON in request", 400

    student_number = request.json.get('student_number', None)
    birth_date = request.json.get('birth_date', None)

    if not student_number or not birth_date:
        return "Missing student_number or birth_date", 400

    if func.check_credentials(student_number, birth_date):
        return "Login successful", 200
    else:
        return "Invalid student_number or birth_date", 401

# 사용가능한 사물함 개수 반환
@app.route('/lockerscount', methods=['GET'])
def get_locker_count():
    # 쿼리 스트링에서 위치 받기
    location = request.args.get('location')

    # 데이터베이스 연결 설정
    db = pymysql.connect(
        host='localhost',
        user='sb',
        password='sb203705',
        db='public_lockers',
        charset='utf8mb4'
    )

    with db.cursor() as cursor:
        # lockers 테이블에서 해당 위치에 대한 사용 가능한 사물함의 수를 카운트
        sql_select = """
        SELECT COUNT(*) 
        FROM lockers 
        WHERE location = %s AND reserved = 0
        """
        cursor.execute(sql_select, (location,))
        locker_count = cursor.fetchone()[0]

    db.close()
    return jsonify(count=locker_count)

# 에약정보 데이터베이스에 추가&종료시간 되면 예약 삭제
@app.route('/reservation', methods=['POST'])
def make_reservation():
    # JSON 데이터 받기
    data = request.get_json()

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
            # reservations 테이블에 데이터 삽입
            sql_insert = """
            INSERT INTO reservations(locker_number, student_number, start_time, end_time)
            VALUES(%s, %s, %s, %s)
            """
            cursor.execute(sql_insert, (data['locker_number'], data['student_number'], data['start_time'], data['end_time']))

            # lockers 테이블에서 해당 사물함의 reserved를 1로 업데이트
            sql_update = """
            UPDATE lockers
            SET reserved = 1
            WHERE locker_number = %s
            """
            cursor.execute(sql_update, (data['locker_number'],))
        
        db.commit()

        # 예약 종료 시간에 실행할 작업 스케줄링
        end_time = parse(data['end_time'])  # 예약 종료시간을 datetime 객체로 변환
        scheduler.add_job(func.end_reservation, 'date', run_date=end_time, args=[data['locker_number']])

    except Exception as e:
        db.rollback()
        return jsonify(status="fail", error=str(e)), 400

    finally:
        db.close()

    return jsonify(status="success"), 200

# 예약 정보 앱에 반환
@app.route('/reservationinfo', methods=['GET'])
def reservationinfo():
    # 쿼리 스트링에서 학생 번호 받기
    student_number = request.args.get('student_number')

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
            # reservations 테이블에서 학생 번호로 조회
            sql = """
            SELECT l.locker_number, l.location, r.end_time, l.reserved
            FROM reservations r
            JOIN lockers l ON r.locker_number = l.locker_number
            WHERE r.student_number = %s
            """
            cursor.execute(sql, (student_number,))
            reservation_info = cursor.fetchone()

        if reservation_info is None:
            return jsonify(status="fail", error="No reservation found for the given student number"), 404

    except Exception as e:
        return jsonify(status="fail", error=str(e)), 400

    finally:
        db.close()

    return jsonify(
        status="success", 
        locker_number=reservation_info[0], 
        location=reservation_info[1], 
        end_time=reservation_info[2].isoformat(), 
        reserved=reservation_info[3]
    ), 200

# 예약 종료시 데이터베이스에서 예약 정보삭제&사물함 정보 업데이트
@app.route('/endreservation', methods=['GET'])
def cancel_reservation():
    # 쿼리 스트링에서 학생 번호와 사물함 번호 받기
    student_number = request.args.get('student_number')
    locker_number = request.args.get('locker_number')

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
            # reservations 테이블에서 학생 번호와 사물함 번호로 조회 후 삭제
            sql_select = """
            SELECT locker_number
            FROM reservations 
            WHERE student_number = %s AND locker_number = %s
            """
            cursor.execute(sql_select, (student_number, locker_number))
            fetched_locker_number = cursor.fetchone()[0]

            if fetched_locker_number is None:
                return jsonify(status="fail", error="No reservation found for the given student number and locker number"), 404

            sql_delete = """
            DELETE FROM reservations
            WHERE student_number = %s AND locker_number = %s
            """
            cursor.execute(sql_delete, (student_number, locker_number))

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
        return jsonify(status="fail", error=str(e)), 400

    finally:
        db.close()

    return jsonify(status="success", reserved=0), 200

# 사물함 예약 정보들 리턴
@app.route('/lockersinfo', methods=['GET'])
def get_lockers():
    # 쿼리 스트링에서 location 받기
    location = request.args.get('location')

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
            # lockers 테이블에서 location 값이 같고 reserved값 조회
            sql_select = """
            SELECT reserved 
            FROM lockers 
            WHERE location = %s
            """
            cursor.execute(sql_select, (location,))
            lockers = cursor.fetchall()

            if not lockers:
                return jsonify(status="fail", error="No lockers found for the given location"), 404

    except Exception as e:
        db.rollback()
        return jsonify(status="fail", error=str(e)), 400

    finally:
        db.close()

    # JSON 응답 생성
    lockers_list = [locker[0] for locker in lockers]

    return jsonify(status="success", reserved=lockers_list), 200

# 잠금 요청이 오면 해당 로직실행
@app.route('/lock', methods=['GET'])
def lock_data():
    locker_number = request.args.get('locker_number', None)

    if not locker_number:
            return "Missing locker_number"
    
    conn = pymysql.connect(
        host='localhost',
        user='sb',
        password='sb203705',
        db='public_lockers',
        charset='utf8mb4'
    )
    cursor = conn.cursor()

    # Update query to include the locker number from the request
    query = "UPDATE lockers SET is_locked = 1 WHERE locker_number = %s;"
    cursor.execute(query, (locker_number,))

    conn.commit()
    cursor.close()

    return "lock"

# 잠금해제 요청이 오면 해당 로직실행
@app.route('/unlock', methods=['GET'])
def unlock_data():
    locker_number = request.args.get('locker_number', None)

    if not locker_number:
        return "Missing locker_number"

    conn = pymysql.connect(
        host='localhost',
        user='sb',
        password='sb203705',
        db='public_lockers',
        charset='utf8mb4'
    )
    cursor = conn.cursor()

    # Update query to include the locker number from the request
    query = "UPDATE lockers SET is_locked = 0 WHERE locker_number = %s;"
    cursor.execute(query, (locker_number,))

    conn.commit()
    cursor.close()

    return "unlock"

#사물함의 잠금상태 반환
@app.route('/lockstate')
def lock_state():
    conn = pymysql.connect(
        host='localhost',
        user='sb',
        password='sb203705',
        db='public_lockers',
        charset='utf8mb4'
    )
    cursor = conn.cursor()
    query = "SELECT * FROM lockers WHERE locker_number = 'E1';"
    cursor.execute(query)
    result = cursor.fetchone()  # 쿼리 결과를 가져옴
    conn.close()
    if result:
        lock_state = result[2]  # lockers 테이블의 3번째 컬럼(상태) 값을 가져옴
        print(lock_state)
        return str(lock_state)
    else:
        return "Locker not found"

if __name__ == '__main__':
    app.run(host="0.0.0.0", port="3000", debug= True)