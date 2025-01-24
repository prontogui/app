import 'package:dartlib/dartlib.dart';

class EmbodimentArgs {
  EmbodimentArgs(this.primitive, {this.parentIsTopView = false});

  final Primitive primitive;
  //final Map<String, dynamic> embodimentMap;
  final bool parentIsTopView;
}
