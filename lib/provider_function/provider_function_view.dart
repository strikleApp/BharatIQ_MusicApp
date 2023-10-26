import 'package:flutter/material.dart';
import 'package:musicapp/screens/loading_page.dart';
import 'package:provider/provider.dart';

import 'provider_function_provider.dart';

class ProviderFunctionPage extends StatelessWidget {
  const ProviderFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProviderFunctionProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {


    return  const LoadingScreen();
  }
}

