import 'package:flutter/material.dart';
import 'package:twitter/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  const AuthField(
      {super.key, required this.controller, required this.hintText,required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText:obscure,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Pallete.blueColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Pallete.greyColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(22),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18,
          )),
    );
  }
}
