import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:teste_onfly/api/expense_api.dart';
import 'package:teste_onfly/model/expense_dao.dart';
import 'package:teste_onfly/model/expense_model.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/util/metodos.dart';
import 'package:teste_onfly/util/snackbar_util.dart';

part 'expense_controller.g.dart';

class ExpenseController = _ExpenseController with _$ExpenseController;

abstract class _ExpenseController with Store {

  final _expenseApi = ExpenseApi();

  @observable
  ObservableList<ExpenseModel> expenseList = ObservableList();

  @observable
  bool loading = false;

  @action
  getExpense() async {
    loading = true;
    expenseList.clear();
    expenseList = ObservableList();
    if (frwkLogin.currentUser != null && frwkLogin.currentUser!.login != null) {
      await _expenseApi.getExpense(login: frwkLogin.currentUser!.login!).then((response) async {
        var list = response["items"] as List;
        this.expenseList.addAll(
            list.map((expense) => ExpenseModel.map(expense)).toList());
      }).whenComplete(() {
        loading = false;
        _getLocalExpenses();
      });
    }
  }

  @action
  createExpense(ExpenseModel expense, {bool getExpense = true }) async {
    loading = true;
    if (frwkLogin.currentUser != null && frwkLogin.currentUser!.login != null) {
      await _expenseApi.postExpense(login: frwkLogin.currentUser!.login!, expense: expense).then((response) async {
        SnackbarUtil.snackSucesso("Despesa criada com sucesso!");
        if(getExpense){
          this.getExpense();
        }
      }).whenComplete(() => loading = false);
    }
  }

  @action
  updateExpense(ExpenseModel expense) async {
    loading = true;
    if (frwkLogin.currentUser != null && frwkLogin.currentUser!.login != null) {
      await _expenseApi.patchExpense(login: frwkLogin.currentUser!.login!, expense: expense).then((response) async {
        SnackbarUtil.snackSucesso("Despesa editada com sucesso!");
        getExpense();
      }).whenComplete(() => loading = false);
    }
  }

  @action
  deleteExpense(ExpenseModel expense) async {
    loading = true;
    if (frwkLogin.currentUser != null && frwkLogin.currentUser!.login != null) {
      await _expenseApi.deleteExpense(login: frwkLogin.currentUser!.login!, expense: expense).then((response) async {
        SnackbarUtil.snackError("Despesa excluida com sucesso!");
        getExpense();
      }).whenComplete(() => loading = false);
    }
  }

  @action
  void updateExpenseList(int index, ExpenseModel value){
    expenseList.removeWhere((expense) => expense.id == value.id);
    expenseList.insert(index, value);
  }

  Future init() async{
    expenseList.clear();
    expenseList = ObservableList();
    await getExpense();
    await _getLocalExpenses();
  }

  Future _getLocalExpenses() async{
    final expenseDao = ExpenseDao();
    List<ExpenseModel> listExpenses = await expenseDao.findAll();

    for(ExpenseModel expense in listExpenses){
      expense.isLocal = true;
      expenseList.add(expense);
    }
  }

  Future sendLocalExpenses() async{
    if(await Metodos.hasNetwork()){
      final expenseDao = ExpenseDao();
      List<ExpenseModel> listExpenses = await expenseDao.findAll();

      if(listExpenses.isNotEmpty){
        for(ExpenseModel expense in listExpenses){
          await createExpense(expense, getExpense: false);
          await expenseDao.delete(expense.idLocal!);
        }
        //await expenseDao.deleteAll();
      }
    }
  }

}