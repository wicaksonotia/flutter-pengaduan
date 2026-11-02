import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showNewsDeleteDialog({required String title}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Hapus Berita'),
      content: Text('Apakah kamu yakin ingin menghapus "$title"?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  return result == true;
}
