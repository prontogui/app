import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart'
    as cpplus;

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

class ColorChooserState extends State<ColorChooser> {
  late Color chosenColor;

  @override
  void initState() {
    super.initState();
    chosenColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.palette),
      onPressed: () {
        show(context);
      },
    );
  }

  void changeColor(Color color) {
    setState(() => chosenColor = color);
  }

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
}
