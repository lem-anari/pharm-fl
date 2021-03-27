import 'connection.dart';
// import 'package:farma_app/domain/user.dart';

class CustomAuth {
  static login(String login, String password) async {
    final conn = await operation().then((result) {
      return result;
    }).catchError((onError) {
      print(onError);
    });
    var result =
        await conn.query("select * from login('$login', '$password');");
    print(result);
    await conn.close();
    return result;
    //return CustomUser.fromPostgre(result);
  }

  // Future<CustomUser> login(String login, String password) async {
  //   final conn = await operation().then((result) {
  //     return result;
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  //   var result =
  //       await conn.query("select * from login('$login', '$password');");
  //   print(result);
  //   await conn.close();
  //   // return result;
  //   return CustomUser.fromPostgre(result);
  // }

  static register(String login, String password) async {
    var conn = await operation().then((result) {
      print(result);
      return result;
    }).catchError((onError) {
      print(onError);
    });
    print(conn);
    var result =
        await conn.query("select * from signup('$login', '$password');");
    await conn.close();
    print(result);
    return result;
  }
}

//   create table med_user(
// 	id serial primary key,
// 	login varchar(100) not null unique,
// 	password varchar(100) not null
// )

// create or replace function login(username varchar, password varchar) returns int as $$
// 	select id from med_user
// 		where
// 			login=username and password=password;
// $$ language sql;

// create or replace function signup(username varchar, password varchar) returns int as $$
// 	INSERT INTO med_user (login, password) VALUES(username, password);
// 	select max(id) from med_user;
// $$ language sql;

// select * from med_user
// select * from signup('test1', 'test');
// grant SELECT, INSERT, DELETE , UPDATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public to admins;
// grant usage, SELECT on all sequences in schema public to admins;
