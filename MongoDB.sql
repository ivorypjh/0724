-- 데이터 1개 삽입
-- Insert 는 deprecated 경고가 발생함
db.user.insert({name : "park", age : 25})
-- 결과
-- 성공했기에 True 가 반환되며 objecId 를 리턴함
DeprecationWarning: Collection.insert() is deprecated. Use insertOne, insertMany, or bulkWrite.
{onfig  60.00 KiB
  acknowledged: true,
  insertedIds: { '0': ObjectId("64bdca5f43d18888c1589b83") }
}

-- 배열을 삽입
-- 배열 내에 데이터가 2개이기에 삽입도 2번로 나누어져서 처리됨.
db.user.insert([{name : "kim", age : 24}, {name : "lee", age : 32}])
-- 결과
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId("64bdcb3a43d18888c1589b84"),
    '1': ObjectId("64bdcb3a43d18888c1589b85")
  }
}


-- find() 를 사용해서 Collection 및 데이터 확인
mydb> db.user.find()
-- 결과
[
  { _id: ObjectId("64bdca5f43d18888c1589b83"), name: 'park', age: 25 },
  { _id: ObjectId("64bdcb3a43d18888c1589b84"), name: 'kim', age: 24 },
  { _id: ObjectId("64bdcb3a43d18888c1589b85"), name: 'lee', age: 32 }
]



-- 정렬 조건을 가지는 컬렉션 생성
db.sample.createIndex({age:1}, {unique:true})

-- 컬렉션에 데이터를 삽입
db.sample.insert({age:15})

-- 배열을 삽입 - 동일한 데이터인 15 를 삽입할 때 에러가 발생
db.sample.insert([{age : 14}, {age : 15}, {age : 26}])

-- 데이터 확인 - 삽입 중간에 에러가 발생해서 26 이라는 데이터는 삽입되지 않았음
-- 컬렉션에는 15, 14 데이터만 존재함
db.sample.find()

-- 배열을 삽입 - oredered 를 활용해서 데이터를 멀티 스레드로 삽입
db.sample.insert([{age : 32}, {age : 15}, {age : 26}], {ordered:false})

-- 데이터 확인 
-- 여전히 중간에 에러가 발생하지만 멀티 스레드를 사용하므로
-- 에러가 발생한 뒤인 26 데이터가 삽입됨
-- 많은 양의 중요하지 않은 데이터를 삽입하는 경우에 멀티 스레드가 유용
db.sample.find()



mydb> db.sample.insertOne({age:21})
-- 결과
{
  acknowledged: true,
  insertedId: ObjectId("64bddbc743d18888c1589b90")
}

-- insert 는 정해진 schema가 없기 때문에 다른 형식으로도 삽입 가능
mydb> db.sample.insertOne({age:41, name : "park"})
-- 결과
mydb> db.sample.find()
[
  { _id: ObjectId("64bdd5fd43d18888c1589b86"), age: 15 },
  { _id: ObjectId("64bdd61a43d18888c1589b87"), age: 14 },
  { _id: ObjectId("64bdd6b143d18888c1589b8a"), age: 32 },
  { _id: ObjectId("64bdd6d043d18888c1589b8f"), age: 26 },
  { _id: ObjectId("64bddbc743d18888c1589b90"), age: 21 },
  { _id: ObjectId("64bddc1a43d18888c1589b91"), age: 41, name: 'park' }
]



-- 반복문을 사용해서 여러 개의 데이터 삽입
var number=1
for(var i = 0 ; i < 4; i++){
db.sample.insertOne({age:number+i, name : "user"+i})
}

-- 결과
mydb> db.sample.find()
[
  { _id: ObjectId("64bdd5fd43d18888c1589b86"), age: 15 },
  { _id: ObjectId("64bdd61a43d18888c1589b87"), age: 14 },
  { _id: ObjectId("64bdd6b143d18888c1589b8a"), age: 32 },
  { _id: ObjectId("64bdd6d043d18888c1589b8f"), age: 26 },
  { _id: ObjectId("64bddbc743d18888c1589b90"), age: 21 },
  { _id: ObjectId("64bddc1a43d18888c1589b91"), age: 41, name: 'park' },
  { _id: ObjectId("64bddfde43d18888c1589b92"), age: 1, name: 'user0' },
  { _id: ObjectId("64bde00243d18888c1589b94"), age: 2, name: 'user0' },
  { _id: ObjectId("64bde00243d18888c1589b95"), age: 3, name: 'user1' },
  { _id: ObjectId("64bde00243d18888c1589b96"), age: 4, name: 'user2' }
]



-- mydb 데이터 베이스의 sample 컬렉션에서 age 가 15 인 데이터 조회
mydb> db.sample.find({age : 15})

-- 결과
[ { _id: ObjectId("64bdd5fd43d18888c1589b86"), age: 15 } ]


-- 데이터 삽입
db.animal.insertMany([
	{name : 'bear', age : 12},
	{name : 'cat', age : 2},
	{name : 'rabbit', age : 1},
	{name : 'monkey', age : 3}
])

-- name 이 bear 인 데이터 조회
test> db.animal.find({name : 'bear'})
-- 조회 결과
[ncaught:
  { _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear', age: 12 }
]

-- name 이 bear 이고(AND) age 가 12 인 데이터 조회
test> db.animal.find({name : 'bear'}, {age : 12})
-- 조회 결과
[ { _id: ObjectId("64be0686adb7a7818acb6802"), age: 12 } ] 



-- name 만 조회하기
-- 1 대신 true 도 가능
db.animal.find({}, {name : 1})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear' },
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat' },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit' },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey' }
]

-- name 만 제외하고 조회하기
-- 0 대신 false 도 가능
test> db.animal.find({}, {name : 0})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6802"), age: 12 },
  { _id: ObjectId("64be0686adb7a7818acb6803"), age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), age: 1 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), age: 3 }
]

-- objectID 제외하고 조회
test> db.animal.find({age : {$lt:5}},{_id : false})
[
  { name: 'cat', age: 2 },
  { name: 'rabbit', age: 1 },
  { name: 'monkey', age: 3 }
]



-- age 가 5 보다 작은 데이터 조회
test> db.animal.find({age : {$lt:5}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]

-- name 이 cat 인 데이터 조회
test> db.animal.find({name : {$eq:'cat'}})
-- 조회 결과
[ { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 } ]

-- 동일한 결과
test> db.animal.find({name : 'cat'})

-- name 이 rabbit 이거나 monkey 인 데이터 조회
db.animal.find({name : {$in : ['rabbit', 'monkey']}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]

-- name 이 rabbit 이 아니면서 age 가 10 이하인 데이터 조회
db.animal.find({name : {$nin : ['rabbit']}, age : {$lte : 10}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]



-- name 이 영문 소문자로 시작하면서 ear 로 끝나는 데이터 조회
db.animal.find({name:{$in : [/^[a-z]ear/]}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear', age: 12 }
]

-- name 이 b 로 시작하지 않는 데이터 조회
db.animal.find({name : {$nin : [/^b/]}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]



-- age 가 3 보다 크지 않은 데이터 조회
db.animal.find({age : {$not : {$gt:3}}})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 },
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]

-- age 가 2 이하 이거나 12 인 데이터 조회
db.animal.find({$or : [{age : {$lte : 2}}, {age : 12}]})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear', age: 12 },
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 }
]



-- name 에 t 가 포함된 문자열을 검색
db.animal.find({name : /t/})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 }
]

-- name 이 c 로 시작하는 문자열을 검색
db.animal.find({name : /^c/})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0dd53c687e3813c9c599"), name: 'cammel' }
]

-- name 이 y 로 끝나는 데이터 조회
db.animal.find({name : /y$/})
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6805"), name: 'monkey', age: 3 }
]



-- 데이터로 배열을 가지고 있는 inventory 컬렉션
-- inventory 에서 tags 에 red 가 포함된 데이터 조회
test> db.inventory.find({tags:"red"}, {_id:0})
-- 조회 결과
[
  { item: 'journal', qty: 25, tags: [ 'blank', 'red' ] },
  { item: 'notebook', qty: 50, tags: [ 'red', 'blank' ] },
  { item: 'planner', qty: 75, tags: [ 'blank', 'red' ] }
]

-- score 의 모든 값이 80 보다 크고 90 보다 작은 데이터 조회
db.users.find({scores : {$gt : 80 , $lt : 90}})

-- score 의 값들 중 하나라도 80 보다 크고 90 보다 작은 데이터가 존재하면 조회
db.users.find({scores : {$elemMatch:{$gt : 80 , $lt : 90}}})
-- 조회 결과
[
  {
    _id: ObjectId("64be15f63c687e3813c9c5a0"),
    name: 'matt',
    scores: [ 79, 85, 93 ]
  }
]



-- 순서를 고정하고 데이터를 조회
-- 조건에 or, in, nin 이 없기 때문에 순서까지 일치하는 데이터만 조회
db.inventory.find({tags:["red", "blank"]})
-- 조회 결과
[
  {
    _id: ObjectId("64be0fe53c687e3813c9c59c"),
    item: 'notebook',
    qty: 50,
    tags: [ 'red', 'blank' ]
  }
]

-- tags 에 red 나 blanck 를 포함하는 데이터를 조회
test> db.inventory.find({$or : [{tags : "red"}, {tags: "blank"}]},{ _id : false})
-- 조회 결과
[
  { item: 'journal', qty: 25, tags: [ 'blank', 'red' ] },
  { item: 'notebook', qty: 50, tags: [ 'red', 'blank' ] },
  { item: 'planner', qty: 75, tags: [ 'blank', 'red' ] }
]



-- tags 에서 인덱스 가 1 인 데이터를 조회
db.inventory.find({}, {tags : {$slice : 1}})
-- 조회 결과
[
  {
    _id: ObjectId("64be0fe53c687e3813c9c59b"),
    item: 'journal',
    qty: 25,
    tags: [ 'blank' ]
  },
  {
    _id: ObjectId("64be0fe53c687e3813c9c59c"),
    item: 'notebook',
    qty: 50,
    tags: [ 'red' ]
  },
  {
    _id: ObjectId("64be0fe53c687e3813c9c59d"),
    item: 'paper',
    qty: 100,
    tags: []
  },
  {
    _id: ObjectId("64be0fe53c687e3813c9c59e"),
    item: 'planner',
    qty: 75,
    tags: [ 'blank' ]
  },
  {
    _id: ObjectId("64be0fe53c687e3813c9c59f"),
    item: 'postcard',
    qty: 45,
    tags: [ 'blue' ]
  }
]



-- tags 항목에 데이터를 가지고 있지 않으면(크기가 0이면) 조회
db.inventory.find({tags: {$size : 0}})
-- 조회 결과
[
  {
    _id: ObjectId("64be0fe53c687e3813c9c59d"),
    item: 'paper',
    qty: 100,
    tags: []
  }
]


-- 데이터를 1개만 조회
test> db.animal.findOne()
-- 조회 결과
{ _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear', age: 12 }

-- 데이터를 2개만 조회
test> db.animal.find().limit(2)
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6802"), name: 'bear', age: 12 },
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 }
]

-- 데이터를 1개 건너 뛰고 2개 조회
test> db.animal.find().skip(1).limit(2)
-- 조회 결과
[
  { _id: ObjectId("64be0686adb7a7818acb6803"), name: 'cat', age: 2 },
  { _id: ObjectId("64be0686adb7a7818acb6804"), name: 'rabbit', age: 1 }
]



-- 변수를 설정하고 포인터를 가리키도록 함
var cursor = db.inventory.find()

-- 다음 데이터의 존재 여부를 반환
-- 있으면 true를 반환
cursor.hasNext()

-- 다음 데이터를 하나씩 가져옴
cursor.next()

-- 다음 데이터가 있을 때 하나씩 가져오기
-- 있으면 데이터를 가져오고 없으면 null 을 가져옴
cursor.hasNext() ? cursor.next : null

