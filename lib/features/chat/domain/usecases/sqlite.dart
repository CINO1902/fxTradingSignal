import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/chat/domain/usecases/chatStates.dart';
import 'package:fx_trading_signal/features/chat/presentation/provider/chatProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Stream controller to broadcast updates when messages change.
  final StreamController<List<Map<String, dynamic>>> _messageStreamController =
      StreamController.broadcast();
  final BehaviorSubject<List<Map<String, dynamic>>> _messageSubject =
      BehaviorSubject<List<Map<String, dynamic>>>();

  /// Expose the stream for listening to all messages.
  /// In your UI, you can filter the messages by conversationId.
  Stream<List<Map<String, dynamic>>> get messageStream =>
      _messageSubject.stream;

  /// Getter for the database instance. Initializes the database if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) {
        print("Database opened successfully");
      },
    );
  }

  /// Create the 'messages' table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        convoId Text,
        mongooseId TEXT,
        conversationId TEXT,
        sender TEXT,
        recipient TEXT,
        content TEXT,
        timestamp TEXT,
        isSent INTEGER,
        isRead INTEGER
      )
    ''');

    await db.execute('''
    CREATE TABLE conversation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      conversationId TEXT UNIQUE,
      participants TEXT,
      lastMessage TEXT,
      createdAt TEXT,
      updatedAt TEXT
)
    ''');
  }

  /// Insert a new message into the database and notify listeners.
  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    int id = await db.insert('messages', message);
    await _notifyListeners();
    return id;
  }

  /// Retrieve all messages for a specific conversation, ordered by timestamp.
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final db = await database;
    final messages = await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );

    // Emit local messages immediately
    _notifyListeners();
    return messages;
  }

  /// Retrieve all pending messages (where isSent = 0).
  Future<List<Map<String, dynamic>>> getPendingMessages() async {
    final db = await database;
    return await db.query('messages', where: 'isSent = ?', whereArgs: [0]);
  }

  /// Update the message's sent status and notify listeners.
  Future<int> updateMessageStatus(
      int id, int isSent, timestamp, mongooseId) async {
    final db = await database;
    int result = await db.update(
      'messages',
      {'isSent': isSent, 'timestamp': timestamp, 'mongooseId': mongooseId},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _notifyListeners();
    return result;
  }

  /// Delete a specific message.
  Future<int> deleteMessage(String id) async {
    final db = await database;
    int result =
        await db.delete('messages', where: 'mongooseId = ?', whereArgs: [id]);
    await _notifyListeners();
    return result;
  }

  /// Notify listeners by fetching all messages from the database.
  Future<void> _notifyListeners() async {
    final db = await database;
    List<Map<String, dynamic>> messages =
        await db.query('messages', orderBy: 'timestamp ASC');

    // Ensure stream emits initial data immediately
    if (!_messageStreamController.isClosed) {
      _messageSubject.add(messages);
    }
  }

  /// Dispose of the stream controller when it's no longer needed.
  void dispose() {
    _messageStreamController.close();
  }

  // --------------------------
  // Additional Sync & Incremental Methods
  // --------------------------

  /// Check if there are any local messages for the given conversation.
  Future<bool> hasLocalMessages(String conversationId) async {
    final messages = await getMessages(conversationId);
    // print('here are the messages $messages');
    return messages.isNotEmpty;
  }

  Future<void> initializeMessage() async {
    await _notifyListeners();
  }

  Future<int> insertOrUpdateConversation(Map<String, dynamic> conversation,
      [int? id]) async {
    final db = await database;

    // Use conversation['_id'] as the unique conversation identifier.
    final convId = conversation['_id'] ?? '0001';

    // Convert participants array and lastMessage to JSON strings if present.
    String participantsString = conversation['participants'] != null
        ? jsonEncode(conversation['participants'])
        : '';
    String lastMessageString = conversation['lastMessage'] != null
        ? jsonEncode(conversation['lastMessage'])
        : '';

    // Prepare the data to match your SQLite schema.
    Map<String, dynamic> conversationData = {
      'conversationId': convId,
      'participants': participantsString,
      'lastMessage': lastMessageString,
      'createdAt': conversation['createdAt'],
      'updatedAt': conversation['updatedAt'],
    };

    if (id != null) {
      // id was passed. Check if a conversation exists with that local id.
      final List<Map<String, dynamic>> existingById = await db.query(
        'conversation',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingById.isNotEmpty) {
        // Conversation exists, update it.
        int result = await db.update(
          'conversation',
          conversationData,
          where: 'id = ?',
          whereArgs: [id],
        );
        return result;
      } else {
        if (convId != null) {
          // Check if a conversation with this conversationId already exists.
          final List<Map<String, dynamic>> existingByConvId = await db.query(
            'conversation',
            where: 'conversationId = ?',
            whereArgs: [convId],
          );

          if (existingByConvId.isNotEmpty) {
            // Found an existing conversation; update it.
            int localId = existingByConvId.first['id'];
            await db.update(
              'conversation',
              conversationData,
              where: 'id = ?',
              whereArgs: [localId],
            );

            return localId;
          } else {
            // No conversation with this id exists, so insert a new one.
            int newId = await db.insert('conversation', conversationData);

            return newId;
          }
        } else {
          // No conversation with this id exists, so insert a new one.
          int newId = await db.insert('conversation', conversationData);

          return newId;
        }
      }
    } else {
      if (convId != null) {
        // Check if a conversation with this conversationId already exists.
        final List<Map<String, dynamic>> existingByConvId = await db.query(
          'conversation',
          where: 'conversationId = ?',
          whereArgs: [convId],
        );
        if (existingByConvId.isNotEmpty) {
          // Found an existing conversation; update it.
          int localId = existingByConvId.first['id'];
          await db.update(
            'conversation',
            conversationData,
            where: 'id = ?',
            whereArgs: [localId],
          );
          return localId;
        } else {
          // No conversation exists, so insert a new one.
          int newId = await db.insert('conversation', conversationData);
          return newId;
        }
      } else {
        int newId = await db.insert('conversation', conversationData);
        return newId;
      }
    }
  }

  Future<int> upsertMessage(
      {int? id,
      Map<String, dynamic>? message,
      int? isSent,
      dynamic timestamp,
      dynamic mongooseId,
      dynamic conversation,
      int? isRead}) async {
    final db = await database;

    if (id == null) {
      // No id provided: Insert new message.
      if (message == null) {
        throw ArgumentError('Message map is required for insertion.');
      }

      final existing = await db
          .query('messages', where: 'mongooseId = ?', whereArgs: [mongooseId]);
      if (existing.isNotEmpty) {
        // Record exists, update with optional fields if provided.
        Map<String, dynamic> updateData = {};
        if (isSent != null) updateData['isSent'] = isSent;
        if (timestamp != null) updateData['timestamp'] = timestamp;
        if (mongooseId != null) updateData['mongooseId'] = mongooseId;
        if (conversation != null) updateData['conversationId'] = conversation;
        if (isRead != null) updateData['isRead'] = isRead;

        // Only update if there's something to update.
        if (updateData.isNotEmpty) {
          await db.update(
            'messages',
            updateData,
            where: 'mongooseId = ?',
            whereArgs: [mongooseId],
          );
        }
        await _notifyListeners();
        return 0;
      } else {
        int newId = await db.insert('messages', message);
        await _notifyListeners();
        return newId;
      }
    } else {
      // An id is provided: Check if the record exists.
      final existing =
          await db.query('messages', where: 'id = ?', whereArgs: [id]);

      if (existing.isNotEmpty) {
        // Record exists, update with optional fields if provided.
        Map<String, dynamic> updateData = {};
        if (isSent != null) updateData['isSent'] = isSent;
        if (timestamp != null) updateData['timestamp'] = timestamp;
        if (mongooseId != null) updateData['mongooseId'] = mongooseId;
        if (conversation != null) updateData['conversationId'] = conversation;
        if (isRead != null) updateData['isRead'] = isRead;

        // Only update if there's something to update.
        if (updateData.isNotEmpty) {
          await db.update(
            'messages',
            updateData,
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        await _notifyListeners();
        return id;
      } else {
        // id was provided but record doesn't exist: Insert new message.
        if (message == null) {
          throw ArgumentError(
              'Message map is required for insertion when record does not exist.');
        }
        final existing = await db.query('messages',
            where: 'mongooseId = ?', whereArgs: [mongooseId]);
        if (existing.isNotEmpty) {
          // Record exists, update with optional fields if provided.
          Map<String, dynamic> updateData = {};
          if (isSent != null) updateData['isSent'] = isSent;
          if (timestamp != null) updateData['timestamp'] = timestamp;
          if (mongooseId != null) updateData['mongooseId'] = mongooseId;
          if (conversation != null) updateData['conversationId'] = conversation;
          if (isRead != null) updateData['isRead'] = isRead;

          // Only update if there's something to update.
          if (updateData.isNotEmpty) {
            await db.update(
              'messages',
              updateData,
              where: 'mongooseId = ?',
              whereArgs: [mongooseId],
            );
          }
          await _notifyListeners();
          return id;
        } else {
          int newId = await db.insert('messages', message);
          await _notifyListeners();
          return newId;
        }
      }
    }
  }

  /// Perform an incremental sync by fetching messages from the backend that are newer than the last message.
  Future<void> incrementalSync(String conversationId, WidgetRef ref) async {
    final messages = await getMessages(conversationId);
    print('matching convo  $messages');
    if (messages.isEmpty) {
      print("No local messages found, consider doing a full sync.");
      return;
    }
    final lastMessageTimestamp = messages.last['timestamp'];
    try {
      await ref
          .read(chatProviderController)
          .syncMessage(conversationId, lastMessageTimestamp);
      if (ref.watch(chatProviderController).syncLastChatResult.state ==
          SyncLastChatResultStates.isData) {
        final List<dynamic> newMessages =
            ref.watch(chatProviderController).syncLastChatResult.response;
        for (var msg in newMessages) {
          // Insert each new message into the database.
          await insertMessage({
            'conversationId': conversationId,
            'sender': msg['sender'],
            'recipient': msg['recipient'],
            'content': msg['content'],
            'timestamp': msg['createdAt'],
            'isSent': 1, // Mark as confirmed from backend.
            'isRead': msg['isRead'],
            'mongooseId': msg['_id'],
          });
        }
        // Save the new sync time after a successful sync.
        await saveSyncTime(conversationId, DateTime.now());
      } else {
        print(
            'Incremental sync failed: ${ref.watch(chatProviderController).syncLastChatResult.state}');
      }
    } catch (e) {
      print('Error during incremental sync: $e');
    }
  }

  /// Retrieve all messages for a conversation from the backend and store them locally.
  Future<void> getAllMessage(String conversationId, WidgetRef ref) async {
    try {
      await ref.read(chatProviderController).getallMessages(conversationId);
      if (ref.watch(chatProviderController).getChatResult.state ==
          GetChatResultState.isData) {
        final List<dynamic> newMessages =
            ref.watch(chatProviderController).getChatResult.response['data'];
        for (var msg in newMessages) {
          print(msg);
          // Insert each new message into the database.
          await insertMessage({
            'mongooseId': msg['_id'],
            'conversationId': conversationId,
            'sender': msg['sender'],
            'recipient': msg['recipient'],
            'content': msg['content'],
            'timestamp': msg['createdAt'],
            'isSent': 1,
            'isRead': msg['isRead']
          });
        }
        // Save the new sync time after a successful sync.
        await saveSyncTime(conversationId, DateTime.now());
      } else {
        print(
            'Get message failed: ${ref.watch(chatProviderController).getChatResult.state}');
      }
    } catch (e) {
      print('Error during incremental sync: $e');
    }
  }

  /// Delete all messages from the database.
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('messages');
    print("All messages deleted from database");
    _notifyListeners();
  }

  /// Delete all messages for a specific conversation.
  Future<void> deleteConversation(String conversationId) async {
    final db = await database;
    await db.delete('messages',
        where: 'conversationId = ?', whereArgs: [conversationId]);
    print("Messages deleted for conversation: $conversationId");
    _notifyListeners();
  }

  /// Save the last sync timestamp for the given conversation using SharedPreferences.
  Future<void> saveSyncTime(String conversationId, DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'syncTime_$conversationId', timestamp.toIso8601String());
  }

  /// Retrieve the last sync timestamp for the given conversation from SharedPreferences.
  Future<DateTime?> getLastSyncTime(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final syncTime = prefs.getString('syncTime_$conversationId');
    if (syncTime != null) {
      return DateTime.parse(syncTime);
    }
    return null;
  }

  /// Reinitialize the database by dropping and recreating the 'messages' table.
  Future<void> reinitializeDatabase() async {
    final db = await database;
    // Drop the messages table if it exists.
    await db.execute('DROP TABLE IF EXISTS messages');
    await db.execute('DROP TABLE IF EXISTS conversation');
    // Recreate the messages table.
    await _onCreate(db, 1);
    // Notify any listeners that the database has been reinitialized.
    await _notifyListeners();
    print("Database reinitialized successfully");
  }
}
