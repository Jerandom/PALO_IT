import 'package:flutter/material.dart';

class TextBoxWidget extends StatefulWidget {
  const TextBoxWidget({
    super.key, required
    this.headerText,
    this.hintText = '',
    this.obscureText = false,
    this.height = 100,
    this.controller,
  });

  final TextEditingController? controller;
  final String headerText;
  final String hintText;
  final bool obscureText;
  final double height;

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height, // Set the height as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.headerText),
          const SizedBox(height: 8), // Space between text and text field
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
            ),
            obscureText: widget.obscureText,
          ),
        ],
      ),
    );
  }
}
