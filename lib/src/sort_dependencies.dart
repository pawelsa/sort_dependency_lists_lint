import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/find_unsorted_lists_base.dart';

class SortDependenciesLint extends FindUnsortedListsBase {
  SortDependenciesLint() : super(code: _code, searchPhrase: "Dependency");

  static const _code = LintCode(
    name: 'sort_dependencies',
    problemMessage: 'Dependencies are not sorted by the type name',
    correctionMessage: 'Sort by name',
    errorSeverity: ErrorSeverity.WARNING,
  );
}


