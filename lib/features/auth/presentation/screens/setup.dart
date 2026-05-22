import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_provider.dart';
import 'package:flutter/material.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: AuthProvider(),
      children: (provider, theme) {
        return [
          
        ];
      },
    );
  }
}
