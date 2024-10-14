import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/find_unsorted_lists_base.dart';

class SortBlocsLint extends FindUnsortedListsBase {
  SortBlocsLint() : super(code: _code, searchPhrase: "Bloc");

  static const _code = LintCode(
    name: 'sort_blocs',
    problemMessage: 'Blocs are not sorted by the type name',
    correctionMessage: 'Sort by name',
    errorSeverity: ErrorSeverity.WARNING,
  );

}
