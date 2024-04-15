import 'package:flutter/material.dart';
import 'package:museum/utils/constants.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.colorDarkBaseBackground,
    colorScheme: const ColorScheme.dark(
        background: AppColors.colorDarkBaseBackground,
    )
);