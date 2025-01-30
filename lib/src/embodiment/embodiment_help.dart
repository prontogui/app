import 'package:flutter/material.dart';
import 'properties.dart';

/*
  Widget incorporatedPadding(Widget child) {
    if (paddingLeft != 0.0 || paddingRight != 0.0) {
      return Padding(
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
        child: child,
      );
    }

    return child;
  }
*/

/// Encloses a Widget [content] with a SizingBox if properties specify a width
/// and/or height.  It also encloses the [content] with an Expanded widget
/// depending on the parent widget type.  This is necessary to avoid the dreaded
/// Flutter exceptions related to unbound viewports.
Widget encloseWithSizingAndBounding(
    Widget content, CommonPropertyAccess props, String parentWidgetType,
    {bool horizontalUnbounded = false,
    bool verticalUnbounded = false,
    bool useExpanded = false,
    bool useShrink = false}) {
  bool horizontallySized = false;
  bool verticallySized = false;

  // Enclose with sizing if specified

  if (props.width != null && props.height != null) {
    content = SizedBox(
      width: props.width,
      height: props.height,
      child: content,
    );
    horizontallySized = true;
    verticallySized = true;
  } else if (props.width != null) {
    content = SizedBox(
      width: props.width,
      child: content,
    );
    horizontallySized = true;
  } else if (props.height != null) {
    content = SizedBox(
      height: props.height,
      child: content,
    );
    verticallySized = true;
  }

  // Determine whether it needs to be enclosed with a bounding widget, based on
  // bounding at parent level and the content being displayed.

  bool parentHorizontalUnbounded = parentWidgetType == 'Row';
  bool parentVerticalUnbounded = parentWidgetType == 'Column';

  bool needsBounding1 =
      horizontalUnbounded && parentHorizontalUnbounded && !horizontallySized;
  bool needsBounding2 =
      verticalUnbounded && parentVerticalUnbounded && !verticallySized;

  if (needsBounding1 || needsBounding2) {
    if (useExpanded) {
      return Expanded(
        child: content,
      );
    } else if (useShrink) {
      return FittedBox(fit: BoxFit.fitHeight, child: content);
    }
    return Flexible(
      child: content,
    );
  }

  return content;
}
