import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<Uint8List?> pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true
    );

    if (result == null) return null;

    return result.files.single.bytes;
  }

  static Future<String?> pickOutputFolder() async {
    return await FilePicker.platform.getDirectoryPath();
  }
}
