import 'package:flutter/material.dart';

import 'package:wisata_app/src/presentation/animation/fade_animation.dart';
import 'package:wisata_app/src/data/model/wisata.dart';

extension StringExtension on String {
  String get toCapital => this[0].toUpperCase() + substring(1, length);
}

extension WidgetExtension on Widget {
  Widget fadeAnimation(double delay) {
    return FadeAnimation(delay: delay, child: this);
  }
}

extension IterableExtension on List<Wisata> {
  int getIndex(Wisata food) {
    int index = indexWhere((element) => element.id == food.id);
    return index;
  }
}
