import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:farma_app/components/map-src/application-bloc.dart';
import 'package:farma_app/pages/newsPage.dart';
import 'package:farma_app/pages/pharmacyPage.dart';
import 'package:flutter/material.dart';
import 'package:farma_app/components/map.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auditsPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

//  SharedPreferences sharedPreferences;
//  Future <int> fetchNews() async {
//    sharedPreferences = await SharedPreferences.getInstance();
////    sharedPreferences = await SharedPreferences.getInstance();
//    int news = sharedPreferences.getInt("news");
//    sectionIndex = news;
//    print('neeeeeeeeeeeeeeeeeeeeeeews');
//    print(news);
//    return sectionIndex;
//  }

//  @override
//  void initState(){
//    fetchNews().then((value) {
//      setState((){
////        sectionIndex = news;
//      });
//    });
//    super.initState();
//  }
  @override
  Widget build(BuildContext context) {
    // operation();
    var navigationBar = SingleChildScrollView(
        child: Column(children: [
          CurvedNavigationBar(
            key: _bottomNavigationKey,
            items: const <Widget>[
              Icon(Icons.local_pharmacy_outlined),
              Icon(Icons.person_add_alt),
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
          )]));





    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      // return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(240, 220, 250, 0.95),//color app

        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Colors.black12,
          title: Align (
            child:
            Text(' ' +
              (sectionIndex == 0
                  ? 'Аптеки'
                  : sectionIndex == 1
                      ? 'Аудиты'
                      : sectionIndex == 2
                          ? 'Карта'
//                            : sectionIndex == 3
//                            ? 'News'
                            : 'Карта'),
              style: TextStyle(fontWeight: FontWeight.normal),),
              alignment: Alignment.center
          ),
//          leading: Icon(Icons.medical_services),
//          actions: <Widget>[
//            TextButton.icon(
//                onPressed: () {
//                  AuthService().logOut();
//                },
//                icon: Icon(Icons.supervised_user_circle, color: Colors.white),
//                label: SizedBox.shrink())
//          ],
        ),
        // body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
        body: (sectionIndex == 0)
            ? PharmacyPage()
            : (sectionIndex == 1)
              ? AuditsPage()
//              : (sectionIndex == 3)
//                ? NewsPage()
                : (sectionIndex == 2)
                    ? HomeScreen()
                    : HomeScreen(),
        bottomNavigationBar: navigationBar,
      ),
    );
  }
}
