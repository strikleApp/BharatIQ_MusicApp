import 'package:flutter/material.dart';
import 'package:musicapp/constants/color.dart';
import 'package:musicapp/provider_function/provider_function_provider.dart';
import 'package:musicapp/screens/home_page.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<void> getFuture;

  Future<void> initial() async {
    if (mounted) {
     await Provider.of<ProviderFunctionProvider>(context, listen: false)
          .fillVideoSearchList(search: "Latest Music");
    }

  }

  @override
  void initState() {
    getFuture = initial();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (Provider.of<ProviderFunctionProvider>(context)
            .searchList
            .isNotEmpty) {
          return const Home();
        }
        return Container();
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 2,
              shape: const CircleBorder(),
              child: SizedBox(
                height: 80,
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircularProgressIndicator(
                    color: AppColor.tertiary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Getting songs for you.\n Please Wait...",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
