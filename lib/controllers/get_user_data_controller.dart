import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataController extends GetxController{
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uid)async{
     final QuerySnapshot userData = await _firestore.collection('users').where('uId',isEqualTo: uid).get();
     return userData.docs;
  }
  
}