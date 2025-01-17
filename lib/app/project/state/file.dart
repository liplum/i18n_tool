import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/model/file.dart';

final $fileContent = AsyncNotifierProvider.family.autoDispose<FileContentNotifier, FileContent, String>(
  FileContentNotifier.new,
);

class FileContentNotifier extends AutoDisposeFamilyAsyncNotifier<FileContent, String> {
  @override
  Future<FileContent> build(String arg) async {
    final file = File(arg);
    final stream = file.watch().listen((event) async {
      if (event.type == FileSystemEvent.modify) {
        state = AsyncValue.loading();
        final newContent = await file.readAsString();
        state = AsyncValue.data(FileContent(
          content: newContent,
        ));
      }
    });
    ref.onDispose(() {
      stream.cancel();
    });
    final initialContent = await file.readAsString();
    return FileContent(
      content: initialContent,
    );
  }
}
