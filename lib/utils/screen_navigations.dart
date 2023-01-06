import 'package:flutter/material.dart';

navigateToNext(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}
