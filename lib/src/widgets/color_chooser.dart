import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart'
    as cpplus;
import 'popup.dart';

/*
class ColorChooser extends StatelessWidget {
  const ColorChooser(
      {super.key,
      this.initialColor = Colors.white,
      required this.onColorPicked});

  final Color initialColor;
  final void Function(Color color) onColorPicked;

  @override
  Widget build(BuildContext context) {
    return Popup(
      child: (context, controller) => IconButton(
        icon: const Icon(Icons.palette),
        onPressed: controller.show,
      ),
      follower: (context, controller) => PopupFollower(
        onDismiss: controller.hide,
        child: SingleChildScrollView(
          child: cpplus.ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onColorPicked,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
      ),
    );
  }
}
*/

/// Shows an icon button that displays a popup dialog providing the user
/// a visual/colorful means to choose a color.
class ColorChooser extends StatefulWidget {
  const ColorChooser(
      {super.key,
      this.initialColor = Colors.white,
      required this.onColorPicked});

  final Color initialColor;
  final void Function(Color color) onColorPicked;

  @override
  State<StatefulWidget> createState() {
    return ColorChooserState();
  }
}

// The only reason ColorChooser needs to be a StatefulWidget is because the ColorPicker
// widget calls onColorChanged multiple times as the user navigates color choices up
// when user finishes the selection.  Here we only need to call back once with new
// color choice once popup is dismissed.
class ColorChooserState extends State<ColorChooser> {
  late Color chosenColor;

  void changeColor(Color color) {
    setState(() => chosenColor = color);
  }

  @override
  void initState() {
    super.initState();
    chosenColor = widget.initialColor;
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    chosenColor = widget.initialColor;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Popup(
      followerAnchor: Alignment.centerLeft,
      flip: true,
      child: (context, controller) => IconButton(
        icon: const Icon(Icons.palette),
        onPressed: controller.show,
      ),
      follower: (context, controller) => PopupFollower(
        onDismiss: () {
          controller.hide();
          widget.onColorPicked(chosenColor);
        },
        child: Container(
          width: 400,
          height: 475,
          color: theme.colorScheme.surfaceContainer,
          child: cpplus.ColorPicker(
            pickerColor: chosenColor,
            onColorChanged: changeColor,
            portraitOnly: true,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
      ),
    );
  }

// Another approach that uses an AlertDialog instead of a Popup
/*
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a color'),
          content: SingleChildScrollView(
            child: cpplus.ColorPicker(
              pickerColor: chosenColor,
              onColorChanged: changeColor,
            ),
            // Use Material color picker:
            //
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   showLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
            //
            // child: MultipleChoiceBlockPicker(
            //   pickerColors: currentColors,
            //   onColorsChanged: changeColors,
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Accept'),
              onPressed: () {
                // setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
                widget.onColorPicked(chosenColor);
              },
            ),
          ],
        );
      },
    );
  }
  */
}
