# mongo db 사용을 위한 패키지 import
from pymongo import MongoClient

# 연결
conn = MongoClient('localhost')
print(conn)

# 데이터 베이스 사용 설정, 이름은 mydb
db = conn.mydb # db가 없으면 생성됨

# 컬렉션 설정, 이름은 emp
collec = db.emp

# 컬렉션에 데이터 1개 삽입
# 삽입, 삭제 또는 갱신을 하게 되면 결과를 리턴함
# 조회처럼 눈에 보이는 결과가 없기 때문에 따로 확인이 필요함
resultOne = collec.insert_one({"empno" : "1001", "name" : "kim", "age" : 23})
print(resultOne.acknowledged)
print(resultOne.inserted_id)

# 데이터 여러 개 삽입
resultMany = collec.insert_many([{"empno" : "1002", "name" : "park", "age" : 24},
                    {"empno" : "1003", "name" : "jang", "age" : 32}
                    ])

# 여러 데이터를 삽입해서 결과로 반환되는 ObjectId 도 여러 개
print(resultMany.acknowledged)
print(resultMany.inserted_ids)

# 삽입이 성공적으로 이루어졌다고 True 가 반환되더라도
# 실제 db에서 확인을 해줘야 함
# mongo DB는 복사를 만들었다가 시간이 생길 때 원본 db에 반영하므로 시간이 걸릴 수 있음
# db에 따라서 commit을 해야 반영이 되기도 함(mongo DB는 commit 없어도 반영 됨)


# 데이터 조회
# 데이터를 조회하면 Cursor 를 리턴함
result = collec.find()
# Cursor object 를 출력
print(result)

# Cursor 는 반복문을 사용한 조회가 가능
# cursor 를 순서대로 접근하면 데이터가 dict로 접근 가능
# cursor 는 앞으로만 진행하기 때문에 한 번 사용한 이후에는 재사용 불가능
for items in result:
    print(items)
    print(type(items)) # 타입은 dict
    print(items.get("name")) # 순서대로 name 출력

# RDBMS는 조회 결과가 dict 가 아니라 tuple 로 리턴


# 조건 설정 후 정렬
# 나이가 30 보다 적은 데이터를 나이 순서대로 정렬
result = collec.find({"age" : {"$lt" : 30}}).sort("age")
for items in result:
    print(items)


# 데이터 수정
# 수정할 데이터가 있는 곳에는 $set 연산자를 사용해야 함
collec.update_many(
    {'empno' : '1001'},
    {'$set' : {'name' : 'han'}}
)