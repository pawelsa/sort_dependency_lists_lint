import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sort_dependency_lists_lint/src/sort_blocs.dart';
import 'package:sort_dependency_lists_lint/src/sort_dependencies.dart';
import 'package:sort_dependency_lists_lint/src/sort_mocks.dart';

PluginBase createPlugin() => _SortListPlugin();

class _SortListPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs _) => [
    SortDependenciesLint(),
    SortMocksLint(),
    SortBlocsLint(),
  ];
}