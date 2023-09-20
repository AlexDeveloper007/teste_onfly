// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExpenseController on _ExpenseController, Store {
  late final _$expenseListAtom =
      Atom(name: '_ExpenseController.expenseList', context: context);

  @override
  ObservableList<ExpenseModel> get expenseList {
    _$expenseListAtom.reportRead();
    return super.expenseList;
  }

  @override
  set expenseList(ObservableList<ExpenseModel> value) {
    _$expenseListAtom.reportWrite(value, super.expenseList, () {
      super.expenseList = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_ExpenseController.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$getExpenseAsyncAction =
      AsyncAction('_ExpenseController.getExpense', context: context);

  @override
  Future getExpense() {
    return _$getExpenseAsyncAction.run(() => super.getExpense());
  }

  late final _$createExpenseAsyncAction =
      AsyncAction('_ExpenseController.createExpense', context: context);

  @override
  Future createExpense(ExpenseModel expense, {bool getExpense = true}) {
    return _$createExpenseAsyncAction
        .run(() => super.createExpense(expense, getExpense: getExpense));
  }

  late final _$updateExpenseAsyncAction =
      AsyncAction('_ExpenseController.updateExpense', context: context);

  @override
  Future updateExpense(ExpenseModel expense) {
    return _$updateExpenseAsyncAction.run(() => super.updateExpense(expense));
  }

  late final _$deleteExpenseAsyncAction =
      AsyncAction('_ExpenseController.deleteExpense', context: context);

  @override
  Future deleteExpense(ExpenseModel expense) {
    return _$deleteExpenseAsyncAction.run(() => super.deleteExpense(expense));
  }

  late final _$_ExpenseControllerActionController =
      ActionController(name: '_ExpenseController', context: context);

  @override
  void updateExpenseList(int index, ExpenseModel value) {
    final _$actionInfo = _$_ExpenseControllerActionController.startAction(
        name: '_ExpenseController.updateExpenseList');
    try {
      return super.updateExpenseList(index, value);
    } finally {
      _$_ExpenseControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
expenseList: ${expenseList},
loading: ${loading}
    ''';
  }
}
