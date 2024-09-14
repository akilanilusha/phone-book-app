import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqliteapp/models/contact_model.dart';

class DbController {
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE ,
            name TEXT ,
            number TEXT)''');
      },
    );
  }

  static Future<void> createNew(String name, String number) async {
    final db = await initDB();
    await db.insert(
      'contacts',
      {
        'name': name,
        'number': number,
      },
    );
  }

  static Future<List<Contact>> getContacts() async {
    final db = await initDB();
    final contactsData = await db.query('contacts');
    List<Contact> contacts =
        contactsData.map((e) => Contact.fromMap(e)).toList();
    return contacts;
  }

  static Future<void> upDate(Contact contact) async {
    final db = await initDB();
    await db.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  static Future<void> deleteContact(int id) async {
    final db = await initDB();
    db.delete('contacts', where: 'id=?', whereArgs: [id]);
  }
}
