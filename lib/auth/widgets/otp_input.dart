import 'package:flutter/material.dart';

class OTPInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;

  OTPInput({
    required this.controller,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return Container(
          width: 40,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(counterText: ''),
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}