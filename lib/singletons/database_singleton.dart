import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const criarTabelasLista = [
  "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, cpf TEXT, nome TEXT, email TEXT, login TEXT, senha TEXT, avatar TEXT)",
  "CREATE TABLE sell (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, id_user INTEGER, FOREIGN KEY (id_user) REFERENCES usuario(id))",
];

class DatabaseSingleton {
  DatabaseSingleton._privateConstructor();

  static final DatabaseSingleton _instance =
      DatabaseSingleton._privateConstructor();

  static DatabaseSingleton get instance => _instance;

  late Database db;

  DatabaseSingleton(this.db);

  static Future<DatabaseSingleton> startDatabase() async {
    String dir = join(await getDatabasesPath(), "database.db");

    // delete database
    // await deleteDatabase(dir);
    DatabaseSingleton.instance.db = await openDatabase(
      dir,
      onCreate: (db, version) async {
        for (var sql in criarTabelasLista) {
          await db.execute(sql);
        }
        //  criar usuario admin apenas ao criar o banco
        await db.insert("usuario", {
          "cpf": "12345678910",
          "nome": "Admin",
          "email": "admin@gmail.com",
          "login": "admin",
          "senha": "123456",
          "avatar": "",
        });
        await db.insert("sell",{
          "date" : "25/02/2020",
          "id_user" : 1,
        });
          await db.insert("sell",{
          "date" : "10/07/2022",
          "id_user" : 1,
        });
        await db.insert("sell",{
          "date" : "26/11/2019",
          "id_user" : 1,
        });
        debugPrint("Database created");
      },
      version: 1,
    );
    return DatabaseSingleton.instance;
  }
}
