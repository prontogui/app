# app
The Flutter App that renders the GUI.

## How to add a new primitive
1. Create a new .dart file in lib/primitive with a name corresponding to the name of the primitive.  Follow the example of existing primitives.
1. Create the associated test .dart file as test/primitive/xxxx_test.dart.
1. Write the initial skeleton code for the primitive.  I usually copy code from an existing primitive and strip it down to what I need.
1. Write the unit tests.
1. Finish the primitive implementation so tests pass.
1. Add a test to test/primitive/primitive_factory_test.dart.
1. Add case to lib/primitive/primitive_factory.dart.
1. Create a new .dart file in lib/embodiments with a name representing the default embodiment choice.  Again, follow example of existing embodiments.
1. Create a new test .dart file in test/embodiments.
1. Write the unit test for the default embodiement.
1. Implement the embodiment so tests pass.
1. Add a test in test/embodiment/embodifier_test.dart.
1. Update lib/embodiment/embodifier.dart to handle the new primitive and default embodiment.

## Helpful Resources

* Navigation in the app
	* https://docs.flutter.dev/ui/navigation
	* https://docs.flutter.dev/cookbook#navigation

## Problem Solving

### 1 - Exception trying to connect to a server for first time

Exception was similar to:
```
Unhandled Exception: SocketException: Connection failed (OS Error: Operation not permitted, errno = 1), address = jsonplaceholder.typicode.com, port = 443
```

Problem resolution:  needed to add keys to the macOS runner, DebugProfile.entitlements and Release.entitlements configurations.  

```
	<key>com.apple.security.network.client</key>
	<true/>
```

Full details are at:  https://docs.flutter.dev/platform-integration/macos/building#setting-up-entitlements

### 2 - Exception when rendering a TextField inside of a Row widget.

Exception was:

```
The following assertion was thrown during performLayout():


An InputDecorator, which is typically created by a TextField, cannot have an unbounded width.
This happens when the parent widget does not provide a finite width constraint. For example, if the InputDecorator is contained by a Row, then its width must be constrained. An Expanded widget or a SizedBox can be used to constrain the width of the InputDecorator or the TextField that contains it.
'package:flutter/src/material/input_decorator.dart':
Failed assertion: line 952 pos 7: 'layoutConstraints.maxWidth < double.infinity'
```

Problem resolution:  wrapped the TextField with an Expanded widget, per recommendation of the exception.

---
##### Copyright 2025 ProntoGUI, LLC.

