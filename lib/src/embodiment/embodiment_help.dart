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

Border _makeBorder(double l, double r, double t, double b, Color? borderColor) {
  Color color = Colors.black;
  if (borderColor != null) {
    color = borderColor;
  }
  int selector = 0;

  if (l > 0.0) {
    selector += 1000;
  }
  if (r > 0.0) {
    selector += 100;
  }
  if (t > 0.0) {
    selector += 10;
  }
  if (b > 0.0) {
    selector += 1;
  }

  // This is absolutely nuts but BorderSide doesn't have null arguments.

  switch (selector) {
    // Case LRTB
    case 0000:
      return const Border();
    case 0001:
      return Border(bottom: BorderSide(width: b, color: color));
    case 0010:
      return Border(
        top: BorderSide(width: t, color: color),
      );
    case 0011:
      return Border(
          top: BorderSide(width: t, color: color),
          bottom: BorderSide(width: b, color: color));
    case 0100:
      return Border(
        right: BorderSide(width: r, color: color),
      );
    case 0101:
      return Border(
          right: BorderSide(width: r, color: color),
          bottom: BorderSide(width: b, color: color));
    case 0110:
      return Border(
        right: BorderSide(width: r, color: color),
        top: BorderSide(width: t, color: color),
      );
    case 0111:
      return Border(
          right: BorderSide(width: r, color: color),
          top: BorderSide(width: t, color: color),
          bottom: BorderSide(width: b, color: color));
    case 1000:
      return Border(
        left: BorderSide(width: l, color: color),
      );
    case 1001:
      return Border(
          left: BorderSide(width: l, color: color),
          bottom: BorderSide(width: b, color: color));
    case 1010:
      return Border(
        left: BorderSide(width: l, color: color),
        top: BorderSide(width: t, color: color),
      );
    case 1011:
      return Border(
          left: BorderSide(width: l, color: color),
          top: BorderSide(width: t, color: color),
          bottom: BorderSide(width: b, color: color));
    case 1100:
      return Border(
        left: BorderSide(width: l, color: color),
        right: BorderSide(width: r, color: color),
      );
    case 1101:
      return Border(
          left: BorderSide(width: l, color: color),
          right: BorderSide(width: r, color: color),
          bottom: BorderSide(width: b, color: color));
    case 1110:
      return Border(
        left: BorderSide(width: l, color: color),
        right: BorderSide(width: r, color: color),
        top: BorderSide(width: t, color: color),
      );
    case 1111:
      return Border(
          left: BorderSide(width: l, color: color),
          right: BorderSide(width: r, color: color),
          top: BorderSide(width: t, color: color),
          bottom: BorderSide(width: b, color: color));
    default:
      return const Border();
  }
}

/// Encloses a widget [content] with additioanl widgets to apply Padding, Border,
/// Margin, fixed Sizing, and Alignment according the the common properties [args.properties].
/// It also encloses the content with Flexible when there are no horizontal or vertical
/// constraints, as specified in embodiment arguments [args].
Widget encloseWithPBMSAF(Widget content, EmbodimentArgs args,
    {bool horizontalUnbounded = false, bool verticalUnbounded = false}) {
  bool horizontalSized = false;
  bool verticalSized = false;

  var props = args.properties as CommonPropertyAccess;
  var isSelectedFunc = args.callbacks?.isSelected;

  // Are any common properties set or is there selectability? Otherwise, we can
  // skip PBMSA altogether.
  if (props.areCommonProps || isSelectedFunc != null) {
    Color? backgroundColor = props.backgroundColor;

    // Apply padding
    if (props.isPadding) {
      var (l, r, t, b) = _effectiveLRTB(props.paddingAll, props.paddingLeft,
          props.paddingRight, props.paddingTop, props.paddingBottom);

      var padding = EdgeInsets.only(left: l, right: r, top: t, bottom: b);

      content = Padding(
        padding: padding,
        child: content,
      );
    }

    // If using a background color then enclose in ColoredBox
    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor,
        child: content,
      );
    }

    // Apply border
    if (props.isBorder) {
      var (l, r, t, b) = _effectiveLRTB(props.borderAll, props.borderLeft,
          props.borderRight, props.borderTop, props.borderBottom);

      late BoxBorder border;
      var borderColor = props.borderColor;

      border = _makeBorder(l, r, t, b, borderColor);

      content = Container(
          decoration: BoxDecoration(
              // This can be used to set a background color
              //          color: props.backgroundColor,
              border: border),
          //  padding: EdgeInsets.only(left: l, right: r, top: t, bottom: b),
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

    // If selectable then enclose with a ListTile to show selection and handle taps.
    if (isSelectedFunc != null) {
      var indices = args.callbacks?.indexes;
      if (indices != null) {
        var tapHandler = args.callbacks?.onSelection;
        content = ListTile(
          title: content,
          selected: isSelectedFunc(args.callbacks!.indexes),
          isThreeLine: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          onTap: () {
            if (tapHandler != null) {
              tapHandler(indices);
            }
          },
        );

        // Add sizing if unbounded and no sizing specified in corresponding direction.
        // (Note: ListTile is unbounded in horizontal direction)
        if (args.horizontalUnbounded && !horizontalSized) {
          // TODO:  pick a reasonable default width
          const double defaultWidth = 100;
          if (sizing == null) {
            sizing = BoxConstraints.tightFor(width: defaultWidth);
          } else {
            sizing = sizing.tighten(width: defaultWidth);
          }
          horizontalSized = true;
        }
      }
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

        horizontalSized = true;
        verticalSized = true;
      }
    } else {
      // Otherwise, Apply alignment
      double alignX, alignY;
      bool expandX = false;
      bool expandY = false;
      var halign = props.horizontalAlignment;
      var valign = props.verticalAlignment;

      if (halign != null) {
        switch (halign) {
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
      } else {
        alignX = 0.0;
      }

      if (valign != null) {
        switch (valign) {
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
      } else {
        alignY = 0.0;
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
  } // SKIP PBMSA DROPS TO HERE

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
