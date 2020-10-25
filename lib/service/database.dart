import 'package:Seller/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("mechUsers")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  final CollectionReference mechCollection =
      FirebaseFirestore.instance.collection('mechUsers');

  Future<void> updateUserData(
      String services, String username, String area) async {
    return await mechCollection.doc(uid).set({
      'services': services,
      'userName': username,
      'area': area,
    });
  }

  getUserInfo(
    String email,
  ) async {
    return FirebaseFirestore.instance
        .collection("mechUsers")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("mechUsers")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  // ignore: missing_return
  Future<void> addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('mechUsers', arrayContains: itIsMyName)
        .snapshots();
  }

  UserData userdata(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        username: snapshot.data()['userName'],
        services: snapshot.data()['services'],
        area: snapshot.data()['area']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return mechCollection.doc(uid).snapshots().map(userdata);
  }
}
