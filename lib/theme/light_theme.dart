import 'package:flutter/material.dart';
import 'package:museum/utils/constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.colorLightBaseBackground,
  colorScheme: const ColorScheme.light(
    background: AppColors.colorLightBaseBackground
  )
);