import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/model/file.dart';
import 'package:i18n_tool/app/project/state/file.dart';

import '../model/editing.dart';
import '../model/working_project.dart';

final $l10nEditing = AsyncNotifierProvider.family.autoDispose<L10nEditingNotifier, L10nEditing, L10nFileTab>(
  L10nEditingNotifier.new,
);

class L10nEditingNotifier extends AutoDisposeFamilyAsyncNotifier<L10nEditing, L10nFileTab> {
  @override
  Future<L10nEditing> build(L10nFileTab arg) async {
    final fileContent = await ref.watch($fileContent(arg.file.path).future);
    throw 1;
    // return L10nEditing(
    //   locale: arg.file.locale,
    //   collection: collection,
    //   template: template,
    // );
  }
}
