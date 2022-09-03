import 'package:flutter/material.dart';
import 'package:shopping/services/firebase_services.dart';
import 'package:shopping/widgets/custom_action_bar.dart';

class SavedTab extends StatelessWidget {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text("Saved Tab"),
          ),
          CustomActionBar(
            title: "Saved",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
