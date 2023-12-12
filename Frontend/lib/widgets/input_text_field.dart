import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String text;
  final IconData preicon;
  final IconData? suficon;
  final bool? obscureText;
  final Function? onTap;
  final TextEditingController InputController;

  const InputTextField({
    required this.text,
    required this.preicon,
    required this.InputController,
    this.suficon,
    this.obscureText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40, top: 20),
      child: TextFormField(
        controller: InputController,
        obscureText: obscureText ?? false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Icon(
              suficon,
              color: Colors.white,
            ),
          ),
          prefixIcon: Icon(
            preicon,
            color: Colors.white,
          ),
          hintText: text,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
