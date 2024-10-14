import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/sort_list_fix.dart';

abstract class FindUnsortedListsBase extends DartLintRule {
  final String searchPhrase;

  FindUnsortedListsBase({required super.code, required this.searchPhrase});

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry
        .addListLiteral((node) => _checkListLiteral(node, reporter));
  }

  void _checkListLiteral(ListLiteral node, ErrorReporter reporter) {
    final elements = node.elements;
    if (elements.isEmpty) {
      return;
    }

    final typedDependencies = <DartType>[];

    for (final element in elements) {
      if (element is InstanceCreationExpression) {
        final constructorName = element.constructorName;

        if (constructorName.toString().startsWith('$searchPhrase<') == true) {
          final typeArguments =
              constructorName.type.typeArguments?.arguments.firstOrNull?.type;
          if (typeArguments != null) {
            typedDependencies.add(typeArguments);
          }
        }
      }
    }

    // Check if the types are sorted
    for (int i = 0; i < typedDependencies.length - 1; i++) {
      final current = typedDependencies[i];
      final next = typedDependencies[i + 1];
      if (current
              .getDisplayString(withNullability: false)
              .compareTo(next.getDisplayString(withNullability: false)) >
          0) {
        reporter.reportErrorForNode(code, node);
        return;
      }
    }
  }

  @override
  List<Fix> getFixes() => [
      SortListFix(),
    ];
}
