import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class FormRegister extends StatelessWidget {
  String? name;
  String? title;
  TextInputType? textInputType;
  String? hint;

  FormRegister(
      {super.key, this.name, this.title, this.textInputType, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 6),
          FormBuilderTextField(
            name: name ?? '',
            //enabled: !controller.isLoading,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none, //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: AppColors.primaryLight), //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hint ?? '',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.textColour50),
              filled: true,
              fillColor: AppColors.grey.shade100,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            validator: FormBuilderValidators.required(),
            keyboardType: textInputType ?? TextInputType.text,
          ),
        ],
      ),
    );
  }
}
