import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColors.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double width;

  const CustomTextField({
    Key? key,
    required this.title,
    required this.isPassword,
    required this.controller,
    required this.validator,
    required this.width,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * widget.width,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: SvgPicture.asset(
                          _obscureText
                              ? 'assets/svg/eye.svg'
                              : 'assets/svg/eye-slash.svg', // Add an 'eye_off' icon
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              filled: true,
              fillColor: AppColors.kgrayColor50,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xff9C9FAC),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.kprimaryColor300,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
