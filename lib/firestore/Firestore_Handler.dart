import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/Task.dart';
import 'model/User.dart';

class FirestoreHandler {
  static CollectionReference<User> getUserCollection()
  {
    var firestore = FirebaseFirestore.instance;
    var collection = firestore
       .collection(User.collection)
       .withConverter(fromFirestore: (snapshot, options) {
     var data = snapshot.data();
     return User.fromFirestore(data);
   }, toFirestore: (value, options){
         return value.toFirestore();
    }
   );
    return collection;
  }
  static Future<void> creatUser(User user)async {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }
  static Future <User?> readUser(String userId)async{
    var collection = getUserCollection();
    var docRef = collection.doc(userId);
    var docSnapshot  = await docRef.get();
    return docSnapshot.data();
  }
  static CollectionReference<Task> getTaskCollection(String userId){
    var collection = getUserCollection().doc(userId).collection(Task.collectionName).withConverter(
        fromFirestore: (snapshot, options) =>Task.fromFirestore(snapshot.data()) ,
        toFirestore: (value, options) => value.toFirestore());
    return collection;
  }
  static Future<void> createTask(Task task,String userId)async {
    var collection = getTaskCollection(userId);
    var docRef = collection.doc();
    task.id = docRef.id;
    return  docRef.set(task);
  }
  static Future<List<Task>> getTasks(String userId)async{
     var collection = getTaskCollection(userId);
      var snapshot = await collection.get();
      var tasksList = snapshot.docs.map((Snapshot) => Snapshot.data()).toList();
      return tasksList;
  }
  static Stream<List<Task>> getTasksListen(String userId)async*{
    var collection = getTaskCollection(userId);
    var taskQuerysnapshot = await collection.snapshots();
    var listTaskStream = taskQuerysnapshot.map((event) => event.docs.map((event)=> event.data()).toList());
    yield* listTaskStream;
  }
  static Future<void> deleteTask(String userId,String taskId) async {
    var collection = getTaskCollection(userId);
    return collection.doc(taskId).delete();
  }
}
