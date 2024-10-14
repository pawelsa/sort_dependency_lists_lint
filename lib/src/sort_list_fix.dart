import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SortListFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addListLiteral((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      // Extract the elements of the list
      final elements = node.elements;

      // We will reorder the elements here
      final sortedElements =
          elements.whereType<InstanceCreationExpression>().toList()
            ..sort((a, b) {
              final typeA = _getGenericType(a);
              final typeB = _getGenericType(b);

              return typeA.compareTo(typeB);
            });

      final changeBuilder = reporter.createChangeBuilder(
          message: 'Sort by dependency type', priority: 0);

      // Apply the changes
      changeBuilder.addDartFileEdit((builder) {
        final replacement = '''[
\t\t${sortedElements.map((e) => e.toSource()).join(',\n\t')},
\t]'''
            .replaceAll(RegExp(r"((\)){3},)"), "),),),");
        builder.addSimpleReplacement(node.sourceRange, replacement);
      });
    });
  }

  // Helper to get the generic type from Dependency<T>
  String _getGenericType(InstanceCreationExpression expression) {
    final typeArguments =
        expression.constructorName.type.typeArguments?.arguments;
    return typeArguments?.first.toSource() ?? '';
  }
}