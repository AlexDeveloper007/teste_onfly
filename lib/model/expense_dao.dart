
import 'package:sqflite/sqflite.dart';
import 'package:teste_onfly/model/expense_model.dart';
import 'package:teste_onfly/sql/base_dao.dart';
import 'package:teste_onfly/sql/db_helper.dart';

// Data Access Object
class ExpenseDao extends BaseDAO<ExpenseModel>{

  Future<Database> get db => DatabaseHelper.getInstance().db;

  Future<int> save(ExpenseModel expense) async {
    var dbClient = await db;
    var id = await dbClient.insert("expenses", expense.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    //print('id: $id');
    return id;
  }

  Future<int> update(ExpenseModel expense) async {
    var dbClient = await db;
    int updateCount = await dbClient.rawUpdate('''
    UPDATE expenses 
    SET description = ?, amount = ?, expense_date = ?, latitude = ?, longitude = ?
    WHERE id = ?
    ''',
        [expense.description, expense.amount, expense.expenseDateTime.toString(), expense.latitude, expense.longitude, expense.id]);

    print("updateCount: $updateCount");
    return updateCount;

  }

  Future<List<ExpenseModel>> findAll() async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from expenses');

    final expenses = list.map<ExpenseModel>((json) => ExpenseModel.mapLocal(json)).toList();

    return expenses;
  }

  Future<List<ExpenseModel>> findAllByTipo(String tipo) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from expenses where tipo =? ',[tipo]);

    final expenses = list.map<ExpenseModel>((json) => ExpenseModel.mapLocal(json)).toList();

    return expenses;
  }

  Future<ExpenseModel?> findById(int id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from expenses where id = ?', [id]);

    if (list.length > 0) {
      return new ExpenseModel.mapLocal(list.first);
    }

    return null;
  }

  Future<int> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from expenses');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from expenses where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from expenses');
  }

  @override
  ExpenseModel fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

}
