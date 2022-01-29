db = connect("localhost:27017/orion");
db.createCollection("entities");
db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
db.entities.createIndex({"_id.type": 1});
db.entities.createIndex({"_id.id": 1});
