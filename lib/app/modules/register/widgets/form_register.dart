import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class FormRegister extends StatefulWidget {
  String? name;
  String? title;
  TextInputType? textInputType;
  String? hint;
  bool? sufix = true;

  FormRegister(
      {super.key,
      this.name,
      this.title,
      this.textInputType,
      this.hint,
      this.sufix});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 6),
          FormBuilderTextField(
            name: widget.name ?? '',
            //enabled: !controller.isLoading,
            obscureText: widget.sufix ?? false,
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide.none, //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none, //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: AppColors.primaryLight), //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: widget.hint ?? '',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.textColour50),
              filled: true,
              fillColor: AppColors.grey.shade100,
              suffixIcon: widget.sufix == true
                  ? Icon(
                      Icons.lock_outline_rounded,
                      size: 22,
                    )
                  : Text(''),
            ),

            style: Theme.of(context).textTheme.bodyLarge,
            validator: FormBuilderValidators.required(),
            keyboardType: widget.textInputType ?? TextInputType.text,
          ),
        ],
      ),
    );
  }
}
