import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputFieldWidget extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool capitalize;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int lines;
  final bool hasIcon;
  final int? length;
  final bool enabled;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  const InputFieldWidget({
    required this.hintText,
    this.icon = Icons.receipt,
    super.key,
    this.textInputAction = TextInputAction.done,
    this.lines = 1,
    this.length,
    this.keyboardType = TextInputType.text,
    this.capitalize = false,
    this.hasIcon = true,
    this.enabled = false,
    this.onChanged,
    required this.controller,
    this.isPassword = false, required bool obscureText,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();

    passwordVisible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    TextCapitalization textCapitalization;
    if (widget.capitalize) {
      textCapitalization = TextCapitalization.words;
    } else {
      textCapitalization = TextCapitalization.none;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          if (widget.hasIcon)
            Icon(
              widget.icon,
              size: 22,
                color: Colors.black ),
          const SizedBox(width: 15.0),
          Expanded(
            child: TextField(
              obscureText: passwordVisible,
              textInputAction: widget.textInputAction,
              textCapitalization: textCapitalization,
              keyboardType: widget.keyboardType,
              maxLines: widget.lines,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              readOnly: widget.enabled,
              maxLength: widget.length,
              controller: widget.controller,
              canRequestFocus: !widget.enabled,
              showCursor: !widget.enabled,
              onChanged: widget.onChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                counterText: "",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[4+00],fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (widget.isPassword)
            IconButton(
              padding: EdgeInsets.zero,
              style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
              icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off,color: Colors.black,),
            )
        ],
      ),
    );
  }
}
