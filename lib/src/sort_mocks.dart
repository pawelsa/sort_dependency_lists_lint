import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/find_unsorted_lists_base.dart';

class SortMocksLint extends FindUnsortedListsBase {
  SortMocksLint() : super(code: _code, searchPhrase: "MockSpec");

  static const _code = LintCode(
    name: 'sort_mocks',
    problemMessage: 'Mocks are not sorted by the type name',
    correctionMessage: 'Sort by name',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  List<String> get filesToAnalyze => ["test/mocks.dart"];

}
