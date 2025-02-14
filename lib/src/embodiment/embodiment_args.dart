import 'package:dartlib/dartlib.dart';

class EmbodimentArgs {
  EmbodimentArgs(this.primitive,
      {this.parentIsTopView = false,
      this.verticalUnbounded = false,
      this.horizontalUnbounded = false,
      this.usePositioning = false,
      this.id = 0,
      this.isSelected,
      this.onSelection});

  /// The primitive to be embodied.
  final Primitive primitive;

  /// Whether the parent of [primitive] is a top-level view.
  final bool parentIsTopView;

  /// Parent embodiment is unbounded in horizontal direction.
  final bool horizontalUnbounded;

  /// Parent embodiment is unbounded in vertical direction.
  final bool verticalUnbounded;

  /// Parent is using positioning to place this embodiment.
  final bool usePositioning;

  /// The ID to use for callbacks.
  final int id;

  /// A callback to obtain whether this embodiment is selected in a List or other
  /// container-like primitive
  final bool Function(int id)? isSelected;

  /// A callback when the embodiment is selected (e.g., tapped).
  final void Function(int id)? onSelection;
}
