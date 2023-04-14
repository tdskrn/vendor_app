import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:vendor_app/utils/keys.dart';
import 'package:vendor_app/vendor/views/auth/vendor_register_screen.dart';

class VendorAuthScreen extends StatelessWidget {
  const VendorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(providerConfigs: [
            EmailProviderConfiguration(),
            GoogleProviderConfiguration(
                clientId: '1:349800794751:android:b902e8b1fce710116ecd4a'),
            PhoneProviderConfiguration(),
          ]);
        }

        // Render your application if authenticated
        return VendorRegistrationScreen();
      },
    );
  }
}
