import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputMode {
  number,
  text,
}

class TextBoxWidget extends StatefulWidget {
  const TextBoxWidget({
    super.key,
    required this.headerText,
    this.hintText = '',
    this.obscureText = false,
    this.height = 100,
    this.inputMode = InputMode.text,
    this.controller,
    this.hasError,
  });

  final TextEditingController? controller;
  final String headerText;
  final String hintText;
  final bool obscureText;
  final double height;
  final InputMode inputMode;
  final Function(bool?)? hasError;

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  late TextEditingController _controller;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateInput);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validateInput() {
    final String text = _controller.text.trim();
    final int? intValue = int.tryParse(text);

    setState(() {
      if (widget.inputMode == InputMode.number) {
        if (text.isEmpty || intValue == null || intValue == 0) {
          errorText = 'Please enter a valid number';

          if (widget.hasError != null) {
            widget.hasError!(true);
          }
        }
        else {
          errorText = null;

          if (widget.hasError != null) {
            widget.hasError!(false);
          }
        }
      }
      else {
        errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.headerText),
          const SizedBox(height: 8),
          Flexible(
            child: TextField(
              controller: _controller,
              keyboardType: widget.inputMode == InputMode.number
                  ? const TextInputType.numberWithOptions(decimal: false)
                  : TextInputType.text,
              inputFormatters: widget.inputMode == InputMode.number
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget.hintText,
                errorText: errorText,
              ),
              obscureText: widget.obscureText,
            ),
          ),
        ],
      ),
    );
  }
}
