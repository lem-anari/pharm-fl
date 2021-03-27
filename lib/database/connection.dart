import 'package:postgres/postgres.dart';

Future operation() async {
  var connection = PostgreSQLConnection("10.0.2.2", 5432, "heliot",
      username: "admins", password: "admin", useSSL: false);

  await connection.open();
  print("Connected");

  return connection;
}
