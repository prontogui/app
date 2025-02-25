import 'package:dartlib/dartlib.dart';
import 'properties.dart';

/// Information for specialized callbacks when needed.  This is used in cases
/// like List embodiments that show Group items.
class EmbodimentCallbacks {
  const EmbodimentCallbacks(this.id, {this.isSelected, this.onSelection});

  /// The ID to use for callbacks.
  final int id;

  /// A callback to obtain whether this embodiment is selected in a List or other
  /// container-like primitive
  final bool Function(int id)? isSelected;

  /// A callback when the embodiment is selected (e.g., tapped).
  final void Function(int id)? onSelection;
}

class EmbodimentArgs {
  EmbodimentArgs(
    this.primitive, {
    this.modelPrimitive,
    this.parentIsTopView = false,
    this.verticalUnbounded = false,
    this.horizontalUnbounded = false,
    this.usePositioning = false,
    this.callbacks,
  });

  /// The primitive to be embodied.
  final Primitive primitive;

  /// The effective properties after considering any model properties and the specific
  /// properties of the primitive.
  late Properties properties;

  /// The model primitive to consider when preparing embodiment properties.  This can
  /// be null.
  final Primitive? modelPrimitive;

  /// Whether the parent of [primitive] is a top-level view.
  final bool parentIsTopView;

  /// Parent embodiment is unbounded in horizontal direction.
  final bool horizontalUnbounded;

  /// Parent embodiment is unbounded in vertical direction.
  final bool verticalUnbounded;

  /// Parent is using positioning to place this embodiment.
  final bool usePositioning;

  /// Optional callbacks for certain user interactions, e.g. selecting items in a list.
  final EmbodimentCallbacks? callbacks;
}
