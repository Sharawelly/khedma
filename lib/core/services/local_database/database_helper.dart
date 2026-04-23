import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '/core/utils/log_utils.dart';
import '/injection_container.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'Requests';
  static Future<void> initDB() async {
    if (_database != null) {
      return;
    } else {
      try {
        String path =
            '${Platform.isIOS ? getLibraryDirectory() : getDatabasesPath()}magd_masr.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (Database database, int version) async {
            Log.d('database Created');
            if (Platform.isIOS) {
              await database.execute(
                'PRAGMA sqflite -- db_config_defensive_off',
              );
            }
            // await database.execute(
            //     'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, user_id TEXT, provider_id TEXT,service_id TEXT,service_name TEXT,service_type_id TEXT,subcategory_id TEXT,subcategory_name TEXT,subcategory_photo TEXT,price TEXT,quantity TEXT)');
            await database.execute('''
                    CREATE TABLE $_tableName (
                      id INTEGER PRIMARY KEY AUTOINCREMENT,
                      user_id TEXT, 
                      discount TEXT,
                      discount_percentage TEXT,
                      items TEXT
                    )
                  ''');
          },
        );
        Log.d('database Created successfully');
      } catch (e) {
        Log.e('dataBase error ${e.toString()}');
      }
    }
  }

  static Future<int> delete(int id) async {
    return await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /*
  static Future<int> update(String note, int id) async {
    return await _database!.rawUpdate('''
    UPDATE $_tableName
    SET note = ?
    WHERE id = ?
  ''', [note, id]);
  }
 */
  static Future<int> update(String count, int id) async {
    return await _database!.rawUpdate(
      '''
    UPDATE $_tableName
    SET quantity = ?
    WHERE id = ?
  ''',
      [count, id],
    );
  }

  static Future<List<Map<String, dynamic>>> getList() async {
    int? userId = sharedPreferences.getUserId();
    List<Map<String, dynamic>> maps = userId != null
        ? await _database!.query(
            _tableName,
            where: 'user_id = ?',
            whereArgs: [userId.toString()],
          )
        : await _database!.query(_tableName);
    return maps;
  }

  static Future<void> deleteTable() async {
    try {
      String path =
          '${Platform.isIOS ? getLibraryDirectory() : getDatabasesPath()}JZL.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (Database database, int version) async {
          Log.d('database DROP');

          await database.execute('DROP TABLE IF EXISTS $_tableName ');
        },
      );
      Log.d('database DROP successfully');
    } catch (e) {
      Log.e('dataBase DROP error ${e.toString()}');
    }
  }

  static Future<int> deleteTableData() async {
    return await _database!.delete(_tableName);
  }
}
