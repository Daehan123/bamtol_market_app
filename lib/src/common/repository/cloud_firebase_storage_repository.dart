import 'dart:io';
import 'package:get/get.dart';

class CloudFirebaseRepository extends GetxService {
  CloudFirebaseRepository();

  Future<String> uploadFile(String mainPath, File file) async {
    return file.path; 
  }
}