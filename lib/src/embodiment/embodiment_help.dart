import 'package:flutter/material.dart';
import 'embodiment_args.dart';
import 'properties.dart';

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

Border makeBorder(double l, double r, double t, double b, Color? color) {
  bool isL = l > 0.0;
  bool isR = r > 0.0;
  bool isT = t > 0.0;
  bool isB = b > 0.0;

  if (isL) {
    if (isR) {
      if (isT) {
        if (isB) {
          return Border(
              left: BorderSide(width: l, color: color),
              right: BorderSide(width: r, color: borderColor),
              top: BorderSide(width: t, color: borderColor),
              bottom: BorderSide(width: b, color: borderColor));
        }
      }
    }
  }
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
/*
        BorderSide? leftBorder;
        BorderSide? rightBorder;
        BorderSide? topBorder;
        BorderSide? bottomBorder;

        if (l > 0.0) {
          leftBorder = BorderSide(width: l, color: borderColor);
        }
        if (r > 0.0) {
          rightBorder = BorderSide(width: r, color: borderColor);
        }
        if (t > 0.0) {
          topBorder = BorderSide(width: t, color: borderColor);
        }
        if (b > 0.0) {
          bottomBorder = BorderSide(width: b, color: borderColor);
        }
*/

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

    // Apply positioning (if allowed by parent)
    if (args.usePositioning) {
      if (props.isPositioning) {
        double? left = props.left;
        double? right = props.right;
        double? top = props.top;
        double? bottom = props.bottom;
        double? width = props.width;
        double? height = props.height;

        // Only two out of three can be set.  left + right takes precedence.
        if (left != null && right != null && width != null) {
          width = null;
        }

        // Only two out of three can be set.  top + bottom takes precedence.
        if (top != null && bottom != null && height != null) {
          height = null;
        }

        content = Positioned(
            left: left,
            right: right,
            width: width,
            top: top,
            bottom: bottom,
            height: height,
            child: content);
      } else {
        double? width = props.width;
        double? height = props.height;
        double? right;
        double? bottom;

        // if no width specified then expand to full width of CCA
        if (width == null) {
          right = 0.0;
        }
        // if no height specified then expand to full height of CCA
        if (height == null) {
          bottom = 0.0;
        }

        content = Positioned(
            left: 0.0,
            width: width,
            right: right,
            top: 0.0,
            height: height,
            bottom: bottom,
            child: content);
      }
    } else {
      // Otherwise, Apply alignment
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
    }

    // Need Flexible widget to deal with unbounded situation?
    var flexibleReason1 =
        (args.horizontalUnbounded && horizontalUnbounded && !horizontalSized);
    var flexibleReason2 =
        (args.verticalUnbounded && verticalUnbounded && !verticalSized);

    if (flexibleReason1 || flexibleReason2) {
      content = Flexible(child: content);
    }
  } // SKIP PBMSA DROPS TO HERE

/*
  Future possibilities:

  Expanded:

      content = Expanded(child: content);

  Shrink:

    content = FittedBox(fit: BoxFit.fitHeight, child: content);
*/

  return content;
}
