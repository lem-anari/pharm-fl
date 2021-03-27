import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:farma_app/components/active-workouts.dart';
import 'package:farma_app/components/map-src/application-bloc.dart';
import 'package:farma_app/components/workouts-list.dart';
import 'package:farma_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:farma_app/components/map.dart';
import 'package:farma_app/database/connection.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // operation();
    var navigationBar = CurvedNavigationBar(
      key: _bottomNavigationKey,
      items: const <Widget>[
        Icon(Icons.mediation),
        Icon(Icons.search),
        Icon(Icons.map)
      ],
      index: 0,
      height: 50,
      color: Colors.white.withOpacity(0.5),
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.5),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        setState(() => sectionIndex = index);
      },
    );
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      // return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Farma //' +
              (sectionIndex == 0
                  ? 'Active Workouts'
                  : sectionIndex == 1
                      ? 'find Workouts'
                      : sectionIndex == 2
                          ? 'map'
                          : 'map')),
          leading: Icon(Icons.medical_services),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () {
                  AuthService().logOut();
                },
                icon: Icon(Icons.supervised_user_circle, color: Colors.white),
                label: SizedBox.shrink())
          ],
        ),
        // body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
        body: (sectionIndex == 0)
            ? ActiveWorkouts()
            : (sectionIndex == 1)
                ? WorkoutsList()
                : (sectionIndex == 2)
                    ? HomeScreen()
                    : HomeScreen(),
        bottomNavigationBar: navigationBar,
      ),
    );
  }
}
