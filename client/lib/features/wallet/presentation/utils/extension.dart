import 'package:flutter/material.dart';

extension FromContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}
