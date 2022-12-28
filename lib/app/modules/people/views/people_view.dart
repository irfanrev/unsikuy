import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/people_controller.dart';

class PeopleView extends GetView<PeopleController> {
  const PeopleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeopleView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PeopleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
