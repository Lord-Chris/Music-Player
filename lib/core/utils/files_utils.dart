import 'dart:io';
import 'package:musicool/core/models/track.dart';
import 'package:share/share.dart';

class FileUtils {
  final Track file;

  FileUtils(this.file);

  void share() {
    Share.shareFiles([file.filePath]);
  }

  void rename(String newName) {
    // String newPath = File(file.filePath!).parent.path + newName;
    // File(filePath).rename();
    // print('old path is : ${file.filePath}');
    // print('new path is :$newPath');
  }

  void delete() {
    File(file.filePath).delete(recursive: false);
  }
}
