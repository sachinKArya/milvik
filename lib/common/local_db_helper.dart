import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String columnId = '_id';
final String tableDoctorDetails = 'doctor';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "milvikSqlite.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableDoctorDetails (
                id INTEGER PRIMARY KEY AUTOINCREMENT,    
                doctorId TEXT,         
                firstName TEXT,
                lastName TEXT,
                profilePic FILE,
                contactNumber TEXT,
                dateOfBirth TEXT,
                gender TEXT,
                bloodGroup TEXT,
                height TEXT,
                weight TEXT
              )
              ''');
  }

  Future<int> rawInsertDoctorDetaails(
      {String tableData, Map doctorData}) async {
    Database db = await database;
    try {
      var result = await db.rawInsert(tableData, [
        doctorData['id'],
        doctorData['first_name'],
        doctorData['last_name'],
        doctorData['profile_pic'],
        doctorData['primary_contact_no'],
        doctorData['date_of_birth'],
        doctorData['gender'],
        doctorData['blood_group'],
        doctorData['height'],
      ]);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchSelectedDoctorDetail({@required String doctorId}) async {
    try {
      Database db = await database;
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM $tableDoctorDetails WHERE doctorId = ?", [doctorId]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }
}
