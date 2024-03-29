import 'package:flutter/material.dart';

///here you find all constants which can be used in the whole app

///Colors
const kPrimaryColor = Color(0xFFD20A10);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

///Duration (for Animations)
const kAnimationDuration = Duration(microseconds: 200);
