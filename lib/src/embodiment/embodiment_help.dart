import 'package:flutter/material.dart';
import 'embodiment_args.dart';
import 'properties.dart';

/*
  OLD CODE - TOSS ONCE THIS MODULE IS FINISHED

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
/*
  OLD CODE - TOSS ONCE THIS MODULE IS FINISHED

    if (props.border == 'outline') {
      content = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3.0),
        ),
        child: content,
      );

      content = Container(
        padding: const EdgeInsets.all(10.0),
        child: content,
      );
    }
*/
/*

  OLD CODE - TOSS ONCE THIS MODULE IS FINISHED


(double?, double?, double?, double?) _effectiveLRTB(
    double? all, double? l, double? r, double? t, double? b) {
  double? effL, effR, effT, effB;

  if (all != null) {
    effL = all;
    effR = all;
    effT = all;
    effB = all;
  }
  if (l != null) {
    effL = l;
  }
  if (r != null) {
    effR = r;
  }
  if (t != null) {
    effT = t;
  }
  if (b != null) {
    effB = b;
  }
  return (effL, effR, effT, effB);
}
*/

(double, double, double, double) _effectiveLRTB(
    double? all, double? l, double? r, double? t, double? b) {
  double effL = 0.0, effR = 0.0, effT = 0.0, effB = 0.0;

  if (all != null) {
    effL = all;
    effR = all;
    effT = all;
    effB = all;
  }
  if (l != null) {
    effL = l;
  }
  if (r != null) {
    effR = r;
  }
  if (t != null) {
    effT = t;
  }
  if (b != null) {
    effB = b;
  }
  return (effL, effR, effT, effB);
}

/// Encloses a widget [content] with additioanl widgets to apply Padding, Border,
/// Margin, fixed Sizing, and Alignment according the the common properties [props].
/// It also encloses the content with Flexible when there are no horizontal or vertical
/// constraints, as specified in embodiment arguments [args].
Widget encloseWithPBMSAF(
    Widget content, CommonPropertyAccess props, EmbodimentArgs args,
    {bool horizontalUnbounded = false, bool verticalUnbounded = false}) {
  bool horizontalSized = false;
  bool verticalSized = false;

  // Are any common properties set, or can we skip PBMSA altogether?
  if (props.areCommonPropsSet) {
    // Apply padding
    if (props.isPadding) {
      var (l, r, t, b) = _effectiveLRTB(props.paddingAll, props.paddingLeft,
          props.paddingRight, props.paddingTop, props.paddingBottom);

      content = Padding(
        padding: EdgeInsets.only(left: l, right: r, top: t, bottom: b),
        child: content,
      );
    }

    // Apply border
    if (props.isBorder) {
      var (l, r, t, b) = _effectiveLRTB(props.borderAll, props.borderLeft,
          props.borderRight, props.borderTop, props.borderBottom);

      late BoxBorder border;
      var borderColor = props.borderColor;

      if (borderColor != null) {
        border = Border.all(width: 3, color: borderColor);
        border = Border(
            left: BorderSide(width: l, color: borderColor),
            right: BorderSide(width: r, color: borderColor),
            top: BorderSide(width: t, color: borderColor),
            bottom: BorderSide(width: b, color: borderColor));
      } else {
        border = Border(
            left: BorderSide(width: l),
            right: BorderSide(width: r),
            top: BorderSide(width: t),
            bottom: BorderSide(width: b));
      }

      content = Container(
          decoration: BoxDecoration(
              // This can be used to set a background color
              //          color: props.backgroundColor,
              border: border),
          padding: EdgeInsets.only(left: l, right: r, top: t, bottom: b),
          child: content);
    }

    // Get margin
    EdgeInsetsGeometry? margin;
    if (props.isMargin) {
      var (l, r, t, b) = _effectiveLRTB(props.marginAll, props.marginLeft,
          props.marginRight, props.marginTop, props.marginBottom);

      margin = EdgeInsets.only(left: l, right: r, top: t, bottom: b);
    }

    // Get sizing
    BoxConstraints? sizing;
    if (props.isSizing) {
      sizing =
          BoxConstraints.tightFor(width: props.width, height: props.height);
      horizontalSized = props.width != null;
      verticalSized = props.height != null;
    }

    // Apply margin or sizing
    if (margin != null || sizing != null) {
      content = Container(padding: margin, constraints: sizing, child: content);
    }
  } // SKIP PBMSA DROPS TO HERE

  // Apply alignment
  double alignX, alignY;
  bool expandX = false;
  bool expandY = false;
  switch (props.horizontalAlignment) {
    case HorizontalAlignment.left:
      alignX = -1.0;
    case HorizontalAlignment.center:
      alignX = 0.0;
    case HorizontalAlignment.right:
      alignX = 1.0;
    case HorizontalAlignment.expand:
      alignX = 0.0;
      expandX = true;
  }
  switch (props.verticalAlignment) {
    case VerticalAlignment.top:
      alignY = -1.0;
    case VerticalAlignment.middle:
      alignY = 0.0;
    case VerticalAlignment.bottom:
      alignY = 1.0;
    case VerticalAlignment.expand:
      alignY = 0.0;
      expandY = true;
  }

  if (expandX && expandY) {
    // Note:  this probably isn't needed and can use the content as is
    content = Expanded(child: content);
  } else if (expandX) {
    content = Align(
        alignment: Alignment(alignX, alignY),
        child: SizedBox(
          width: double.infinity,
          child: content,
        ));
  } else if (expandY) {
    content = Align(
        alignment: Alignment(alignX, alignY),
        child: SizedBox(
          height: double.infinity,
          child: content,
        ));
  } else {
    content = Align(
      alignment: Alignment(alignX, alignY),
      child: content,
    );
  }

  // Need Flexible widget to deal with unbounded situation?
  var flexibleReason1 =
      (args.horizontalUnbounded && horizontalUnbounded && !horizontalSized);
  var flexibleReason2 =
      (args.verticalUnbounded && verticalUnbounded && !verticalSized);

  if (flexibleReason1 || flexibleReason2) {
    content = Flexible(child: content);
  }

/*
  Future possibilities:

  Expanded:

      content = Expanded(child: content);

  Shrink:

    content = FittedBox(fit: BoxFit.fitHeight, child: content);
*/

  return content;
}
