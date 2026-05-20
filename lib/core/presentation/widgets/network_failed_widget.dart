import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/custom_image.dart';

class NetworkFailedWidget extends StatelessWidget {
  const NetworkFailedWidget(
      {super.key, required this.reloadFunction, this.message, this.buttonText});
  final Function reloadFunction;
  final String? message;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CustomImage(asset: 'assets/images/nointernet.png'),
            ),
            Center(
              child: Text(
                'Whoops!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 25,
                ),
              ),
            ),
            const Gap(10),
            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  message ??
                      'No internet connection found. Check your internet connection and try again!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            const Gap(10),
        
            Button(
              title: buttonText ?? 'Retry',
              onPressed: () {
                reloadFunction();
              },
            )
            // CustomWidget().buttons(
            //     context: context,
            //     buttonWidth: 100,
            //     buttonText: buttonText ?? 'Retry',
            //     function: reloadFunction)
          ],
        ),
      ),
    );
  }
}
