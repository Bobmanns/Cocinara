import 'package:flutter/material.dart';
import 'package:my_cocinara/Classes/recepten.dart';

class BoodschappenNotification extends Notification {
  final List<Ingredient> nieuweBoodschappen;

  const BoodschappenNotification(this.nieuweBoodschappen);
}