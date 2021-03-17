import 'dart:async';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class BaseHelper {

  static String DATABASE_NAME = "sogamax.db";
  static int DATABASE_NUMBER = 1;

  static getPath () async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, BaseHelper.DATABASE_NAME);
  }

  static Future<void> deleteDataBase () async {
    deleteDatabase(await getPath());
  }

  static Future<Database> open({Function onCreate}) async {
    return openDatabase(await getPath(),
        version: BaseHelper.DATABASE_NUMBER,
        onCreate: onCreate,
        onUpgrade: onUpgrade
    );
  }

  static FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('UPGRADE Database !!!!!! OLD: $oldVersion - NEW: $newVersion');
  }

  static Future<bool> isTableExists (Database db, String table) async {
    var cursor = await db.rawQuery("SELECT * FROM sqlite_master WHERE type = 'table' AND name = '$table'");
    if (cursor.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static isColumnExists (Database db, String column, String table) async {
    var isExists = false;
    var cursor = await db.rawQuery("PRAGMA table_info($table)");
    for(Map m in cursor) {
      if( m['name'] == column) {
        isExists = true;
      }
    }
    return isExists;
  }

}