import 'package:link/models/message.dart';
import 'package:link/models/user.dart';
import 'package:link/util/utils.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  final String dbName;
  var logger = Logger();
  Database? db;

  DB({this.dbName = 'link_db'});

  Future<bool> connect() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, dbName);

      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, name TEXT, password TEXT, lat REAL, lng REAL, userType TEXT, timestamp TEXT)',
          );
          await db.execute(
            'CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY AUTOINCREMENT, toId INTEGER, fromId INTEGER, content TEXT, timestamp TEXT)',
          );
        },
      );
      logger.i('Database connected');
      return true;
    } catch (e) {
      logger.e('Database connection error: $e');
      return false;
    }
  }

  Future<bool> close() async {
    try {
      await db?.close();
      logger.i('Database closed');
      return true;
    } catch (e) {
      logger.e('Database close error: $e');
      return false;
    }
  }

  // Method to get table names
  Future<List<String>?> getTableNames() async {
    try {
      final List<Map<String, dynamic>>? tables = await db
          ?.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      List<String>? tableNames =
          tables?.map((table) => table['name'] as String).toList();
      logger.i('Table names: $tableNames');
      return tableNames;
    } catch (e) {
      logger.e('Get table names error: $e');
      return [];
    }
  }

  // Message CRUD operations
  Future<int?> insertMessage(Message message) async {
    try {
      return await db?.insert('messages', message.toMap());
    } catch (e) {
      logger.e('Insert message error: $e');
      return null;
    }
  }

  Future<List<Message>?> getMessages() async {
    try {
      final List<Map<String, dynamic>> maps = await db?.query('messages') ?? [];
      return List.generate(maps.length, (i) {
        return Message.fromMap(maps[i]);
      });
    } catch (e) {
      logger.e('Get messages error: $e');
      return null;
    }
  }

  Future<Message?> getMessageById(int id) async {
    try {
      List<Map<String, dynamic>> results = await db?.query(
            'messages',
            where: 'id = ?',
            whereArgs: [id],
          ) ??
          [];
      if (results.isNotEmpty) {
        return Message.fromMap(results.first);
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Get message by ID error: $e');
      return null;
    }
  }

  Future<int?> updateMessage(Message message) async {
    try {
      return await db?.update(
        'messages',
        message.toMap(),
        where: 'id = ?',
        whereArgs: [message.id],
      );
    } catch (e) {
      logger.e('Update message error: $e');
      return null;
    }
  }

  Future<int?> deleteMessage(int id) async {
    try {
      return await db?.delete(
        'messages',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      logger.e('Delete message error: $e');
      return null;
    }
  }

  // User CRUD operations
  Future<int?> insertUser(User user) async {
    try {
      await connect();
      return await db?.insert('users', user.toMap());
    } catch (e) {
      Util.i('Insert user error: ${e.toString()}');
      return 0;
    } finally {
      await close();
    }
  }

  Future<List<User>?> getUsers() async {
    try {
      final List<Map<String, dynamic>> maps = await db?.query('users') ?? [];
      Util.i(maps);
      return List.generate(maps.length, (i) {
        Util.i(User.fromMap(maps[i]).username);
        return User.fromMap(maps[i]);
      });
    } catch (e) {
      logger.e('Get users error: $e');
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      List<Map<String, dynamic>> results = await db?.query(
            'users',
            where: 'id = ?',
            whereArgs: [id],
          ) ??
          [];
      if (results.isNotEmpty) {
        return User.fromMap(results.first);
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Get user by ID error: $e');
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      await connect();
      List<Map<String, dynamic>> results = await db?.query(
            'users',
            where: 'username = ?',
            whereArgs: [username],
          ) ??
          [];
      if (results.isNotEmpty) {
        return User.fromMap(results.first);
      } else {
        return null;
      }
    } catch (e) {
      Util.e('Get user by username error: $e');
      return null;
    } finally {
      await close();
    }
  }

  Future<int?> updateUser(User user) async {
    try {
      return await db?.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      logger.e('Update user error: $e');
      return null;
    }
  }

  Future<int?> deleteUser(int id) async {
    try {
      return await db?.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      logger.e('Delete user error: $e');
      return null;
    }
  }

  // Join operation to get messages with user details
  Future<List<Map<String, dynamic>>?> getMessagesWithUserDetails() async {
    try {
      return await db?.rawQuery('''
        SELECT messages.id, messages.content, messages.timestamp, 
               users.username AS toUsername, users.name AS toName, 
               u.username AS fromUsername, u.name AS fromName
        FROM messages
        JOIN users ON messages.toId = users.id
        JOIN users AS u ON messages.fromId = u.id
      ''');
    } catch (e) {
      logger.e('Join operation error: $e');
      return null;
    }
  }
}
