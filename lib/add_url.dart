import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/widgets/CustomButton.dart';
import 'package:lit_starfield/lit_starfield.dart';

class AddServerUrl extends StatefulWidget {
  const AddServerUrl({super.key});

  @override
  State<AddServerUrl> createState() => _AddServerUrlState();
}

class _AddServerUrlState extends State<AddServerUrl> {
  var txtCon = TextEditingController().obs;
  var showClear = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => Stack(
            children: [
              const LitStarfieldContainer(),
              SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.2),
                      MyTextField(
                        hintText: "IP : 192.168.0.0",
                        onChanged: (p0) {
                          if (p0.isNotEmpty) {
                            showClear(true);
                          } else {
                            showClear(false);
                          }
                        },
                        icon: showClear.value
                            ? IconButton(
                                onPressed: () {
                                  txtCon.value.text = '';
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        inputController: txtCon.value,
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Submit",
                        onPress: () {
                          if (txtCon.value.text.isNotEmpty) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          } else {
                            SnackBar snackBar = SnackBar(
                              content: const Text(
                                "Please input IP",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor:
                                  context.theme.colorScheme.primary,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController inputController;
  final String? hintText;
  final bool? obscureText;
  final Widget? icon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  const MyTextField({
    super.key,
    required this.inputController,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.icon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        controller: inputController,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: icon,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText ?? 'Paste Url here..https://......... ',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).cardColor, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.75), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.75), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}
