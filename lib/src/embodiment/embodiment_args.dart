import 'package:dartlib/dartlib.dart';

class EmbodimentArgs {
  EmbodimentArgs(this.primitive,
      {this.parentIsTopView = false,
      this.verticalUnbounded = false,
      this.horizontalUnbounded = false,
      this.usePositioning = false,
      this.id = 0,
      this.selectedCallback});

  final Primitive primitive;
  //final Map<String, dynamic> embodimentMap;
  final bool parentIsTopView;
  final bool horizontalUnbounded;
  final bool verticalUnbounded;
  final bool usePositioning;

  final int id;
  final bool Function(int id, {bool? selected})? selectedCallback;
}
