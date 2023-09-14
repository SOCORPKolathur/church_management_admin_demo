import 'package:flutter/material.dart';


class CustomTextField extends StatefulWidget {
  final IconData? icon;
  final String hint;
  final TextEditingController? controller;
  bool passType;
  final String? value;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;

   CustomTextField(
      {super.key,
        this.icon,
        required this.hint,
        this.value,
        required this.passType,
        required this.controller,
        required this.validator,
        required this.onSubmitted,
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isObsecure = false;
  @override
  void initState() {
    if (widget.value != null) {
      widget.controller!.text = widget.value ?? '';
    }
    if(widget.passType){
      isObsecure = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(right: 15),
      height: size.height * 0.08,
      width: size.width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xffD2CECE))
      ),
      child: Center(
        child: TextFormField(
          onFieldSubmitted: widget.onSubmitted,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: isObsecure,
          enableSuggestions: !widget.passType,
          autocorrect: !widget.passType,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: widget.icon != null
                ? Icon(
              widget.icon,
              color: const Color(0xff757879),
            )
                : const CircleAvatar(backgroundColor: Colors.transparent, radius: 5),
            suffixIcon:widget.passType ? IconButton(
              icon: Icon(isObsecure
                  ? Icons.visibility
                  : Icons.visibility_off,color: const Color(0xff757879)),
              onPressed: () {
                setState(() {
                        isObsecure = !isObsecure;
                        },
                );
              },
            ) : null,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color:  Color(0xffA7A1A1),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}