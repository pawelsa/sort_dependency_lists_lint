Lints for sorting list of dependencies/blocs depending on their type

## Features

Detect if list dependency definitions are sorted, if not show warning, and provide a simple fix to sort them.

## Getting started

Add lints to `pubspec.yaml`

```yaml
dev_dependencies:
  # ...
  sort_lists:
    git: <path_to_this_lib>
```

Then in `analysis_options.yaml` configure custom lints:

```yaml
analyzer:
  plugins:
    - custom_lint
```

## Usage

When incorrectly sorted list is detected, it shows warning, and provides a quickfix, to sort them quickly.