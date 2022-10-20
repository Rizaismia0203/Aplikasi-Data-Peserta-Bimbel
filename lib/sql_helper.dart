import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE books_database(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      author TEXT,
      alamat TEXT,
      jenjangpendidikan TEXT,
      matapelajaran TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('books_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // add
  static Future<int> addBimbel(String author, String alamat,
      String jenjangpendidikan, String matapelajaran) async {
    final db = await SQLHelper.db();
    final data = {
      'author': author,
      'alamat': alamat,
      'jenjangpendidikan': jenjangpendidikan,
      'matapelajaran': matapelajaran
    };
    return await db.insert('books_database', data);
  }

  // read
  static Future<List<Map<String, dynamic>>> getBimbel() async {
    final db = await SQLHelper.db();
    return db.query('books_database');
  }

  // update
  static Future<int> updateBimbel(int id, String author, String alamat,
      String jenjangpendidikan, String matapelajaran) async {
    final db = await SQLHelper.db();

    final data = {
      'author': author,
      'alamat': alamat,
      'jenjangpendidikan': jenjangpendidikan,
      'matapelajaran': matapelajaran
    };
    return await db.update('books_database', data, where: "id = $id");
  }

  // delete
  static Future<void> deleteBimbel(int id) async {
    final db = await SQLHelper.db();
    await db.delete('books_database', where: "id = $id");
  }
}
