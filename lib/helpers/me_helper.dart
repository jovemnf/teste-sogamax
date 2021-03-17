import 'dart:async';
import 'package:sogamax_canhotos/models/auth.dart';

import './base_helper.dart';
import "package:sqflite/sqflite.dart";

final String authTable = "auth_table";
final String idColumn = "idColumn";
final String nomeColumn = "nome";
final String accessTokenColumn = "access_token";

class AuthHelper {

  Future<Database> get db async {
    return await initDB();
  }

  Future<void> init () async {
    Database dbContact = await db;
    if(! await BaseHelper.isTableExists(dbContact, authTable)) {
      await reset();
    }
  }

  Future<Database> initDB() async {
    return BaseHelper.open(onCreate: onCreate);
  }

  Future onCreate (Database db, int newerVersion) async {
    print('CREATE ME');
    await create(db);
  }

  Future<Auth> first () async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(
        authTable,
        columns: [
          idColumn, nomeColumn, accessTokenColumn
        ],
        limit: 1
    );

    await dbContact.close();

    if (maps.length > 0) {
      return new Auth.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Auth> get () async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(
        authTable,
        columns: [
          idColumn, nomeColumn, accessTokenColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [1]
    );

    await dbContact.close();

    if (maps.length > 0) {
      return new Auth.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> create (Database db) async {
    await db.execute(
        "CREATE TABLE $authTable ("
            "$idColumn INTEGER PRIMARY KEY, "
            "$nomeColumn TEXT,"
            "$accessTokenColumn TEXT)"
    );
  }

  Future<Auth> insert (Auth me) async {
    Database dbContact = await db;
    await dbContact.insert(authTable, me.toMap());
    await dbContact.close();
    return me;
  }

  Future<int> update(Auth me) async {
    Database dbContact = await db;
    var future = await dbContact.update(authTable, me.toMap(),
        where: "$idColumn = ?",
        whereArgs: [1]
    );
    await dbContact.close();
    return future;
  }

  Future<void> reset () async {
    Database dbContact = await db;
    await dbContact.execute("DROP TABLE IF EXISTS $authTable");
    await create(dbContact);
    await dbContact.close();
  }

  Future<int> delete (int id) async {
    Database dbContact = await db;
    var carro = await dbContact.delete(authTable, where: "$idColumn = ?", whereArgs: [id]);
    await dbContact.close();
    return carro;
  }
}
