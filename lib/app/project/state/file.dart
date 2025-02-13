import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
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
      if (event is FileSystemModifyEvent) {
        state = AsyncValue.loading();
        final newState = await _rebuild(state.value);
        state = AsyncValue.data(newState);
      }
    });
    ref.onDispose(() {
      debugPrint("Watcher [$arg] disposed");
      stream.cancel();
    });
    final initialState = await _rebuild();
    return initialState;
  }

  Future<FileContent> _rebuild([FileContent? prev]) async {
    final file = File(arg);
    final modified = await file.lastModified();
    final initialContent = await file.readAsString();
    return prev?.copyWith(
          lastModifiedAt: modified,
          content: initialContent,
        ) ??
        FileContent(
          lastModifiedAt: modified,
          content: initialContent,
        );
  }
}
