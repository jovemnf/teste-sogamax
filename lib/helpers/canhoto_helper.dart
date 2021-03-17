import 'package:synchronized/synchronized.dart';
import 'package:sogamax_canhotos/models/canhoto.dart';
import 'package:sqflite/sqflite.dart';

import 'base_helper.dart';

final String canhotoTable = "canhoto_table";
final String numeroColumn = "numero";
final String imageColumn = "image";
final String transmitidoColumn = "transmitido";
final String dataColumn = "data";

final _lock = Lock();

class CanhotoHelper {

  Future<Database> get db async {
    return await initDB();
  }

  Future<void> init () async {
    Database dbContact = await db;
    if(! await BaseHelper.isTableExists(dbContact, canhotoTable)) {
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

  Future<void> create (Database db) async {
    await db.execute(
        "CREATE TABLE $canhotoTable ("
            "$numeroColumn TEXT PRIMARY KEY, "
            "$imageColumn TEXT,"
            "$dataColumn INT,"
            "$transmitidoColumn INTEGER)"
    );
  }

  Future<List<Canhoto>> getLasts () async {
    return _lock.synchronized(() async {
      Database dbContact = await db;

      List<Map> maps = await dbContact.rawQuery(
          "SELECT * FROM $canhotoTable ORDER BY $dataColumn desc LIMIT 5");
      await dbContact.close();

      List<Canhoto> list = List();

      for (Map m in maps) {
        list.add(Canhoto.fromMap(m));
      }

      return list;
    });
  }

  Future<Canhoto> get (String numero) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(
        canhotoTable,
        columns: [
          numeroColumn, imageColumn, transmitidoColumn, dataColumn
        ],
        where: "$numeroColumn = ?",
        whereArgs: [numero]
    );

    await dbContact.close();

    if (maps.length > 0) {
      return new Canhoto.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> reset () async {
    Database dbContact = await db;
    await dbContact.execute("DROP TABLE IF EXISTS $canhotoTable");
    await create(dbContact);
    await dbContact.close();
  }

  Future<Canhoto> insert (Canhoto me) async {
    return _lock.synchronized(() async {
      Database dbContact = await db;
      await dbContact.insert(canhotoTable, me.toMap());
      await dbContact.close();
      return me;
    });
  }

  Future<int> update(Canhoto me) async {
    Database dbContact = await db;
    var future = await dbContact.update(canhotoTable, me.toMap(),
        where: "$numeroColumn = ?",
        whereArgs: [me.numero]
    );
    await dbContact.close();
    return future;
  }

}