import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

///
/// Created by alfianhpratama on 08/11/22
///

class ContainerCollapse extends StatefulWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final bool firstCollapseStatus;

  const ContainerCollapse({
    Key? key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.firstCollapseStatus = true,
  }) : super(key: key);

  @override
  State<ContainerCollapse> createState() => _ContainerCollapseState();
}

class _ContainerCollapseState extends State<ContainerCollapse> {
  late bool _isCollapse;
  double _turns = 0;

  @override
  void initState() {
    super.initState();
    _isCollapse = widget.firstCollapseStatus;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: InkWell(
            onTap: () => setState(() {
              _isCollapse = !_isCollapse;
              _turns += 1.0 / 2.0;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: widget.titleStyle ??
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 500),
                    turns: _turns,
                    child: Icon(
                      Icons.expand_more,
                      size: Get.width * 0.08,
                      color: AppColors.textColour100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(height: Get.width * 0.02),
          secondChild: Padding(
            padding: EdgeInsets.all(Get.width * 0.04),
            child: widget.child,
          ),
          crossFadeState: _isCollapse
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
