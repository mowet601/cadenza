import 'package:cadenza/LoginPages/opening.dart';
import 'package:cadenza/modules/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AppPages/MainWidget.dart';
import 'LoginPages/f_services/auth.dart';
import 'modules/library.dart';
import 'modules/queue.dart';

class Wrapper extends StatelessWidget {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Provider.of<Library>(context,listen: false).user = user;
    if (user == null) {
      print(1);
      return Opening();
    } else {
      print(2);
      Provider.of<Queue>(context,listen: false).initializeQueue();
      bool songsReady = Provider.of<Library>(context,listen:false).songsReady;
      if(songsReady)
        return HomePage();
      return FutureBuilder<DocumentSnapshot>(
        future:
            Firestore.instance.collection('libraries').document(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(
              body: Center(child: Text("Ops")),
            );
          if (snapshot.connectionState == ConnectionState.waiting)
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          if (snapshot.connectionState == ConnectionState.done) {
            if(!snapshot.data.exists)
            return Text("ops");
            Provider.of<Library>(context,listen: false)
                .initialzieSongsFromOnline(snapshot.data);
            // print(snapshot.data.data['songs']);
          return HomePage();
        }
        }
      );
    }
  }
}
