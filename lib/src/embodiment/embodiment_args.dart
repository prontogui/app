import 'package:dartlib/dartlib.dart';

class EmbodimentArgs {
  EmbodimentArgs(this.primitive,
      {this.parentIsTopView = false,
      this.verticalUnbounded = false,
      this.horizontalUnbounded = false,
      this.usePositioning = false});

  final Primitive primitive;
  //final Map<String, dynamic> embodimentMap;
  final bool parentIsTopView;
  final bool horizontalUnbounded;
  final bool verticalUnbounded;
  final bool usePositioning;
}
