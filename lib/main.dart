import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicapp/constants/color.dart';
import 'package:musicapp/provider_function/provider_function_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.seedColor,
            primary: AppColor.primary,
            secondary: AppColor.secondary,
            background: AppColor.bgColor,
            tertiary: AppColor.tertiary),
        useMaterial3: true,
      ),
      home: const ProviderFunctionPage()
    );
  }
}
