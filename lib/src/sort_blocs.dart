import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/sort_list_fix.dart';

class SortBlocsLint extends DartLintRule {
  SortBlocsLint() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_blocs',
    problemMessage: 'Blocs are not sorted by the type name',
    correctionMessage: 'Sort by name',
    errorSeverity: ErrorSeverity.WARNING,
  );

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

        // Check if the constructor is for Dependency<T>
        if (constructorName.toString().startsWith('Bloc<') == true) {
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
        reporter.reportErrorForNode(_code, node);
        return;
      }
    }
  }

  @override
  List<Fix> getFixes() {
    return [
      SortListFix(),
    ];
  }
}
