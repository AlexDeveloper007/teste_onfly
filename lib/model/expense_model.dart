import 'package:teste_onfly/sql/entity.dart';

class ExpenseModel extends Entity{

  int? idLocal;
  String id = "";
  String? description;
  String? expenseDate;
  String? latitude;
  String? longitude;
  double? amount;
  DateTime? expenseDateTime;
  bool isLocal = false;

  ExpenseModel();

  ExpenseModel.map(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    expenseDate = json['expense_date'] ?? "";
    amount = double.parse(json['amount'].toString()) ?? 0.0;
  }

  ExpenseModel.mapLocal(Map<String, dynamic> json) {
    idLocal = json["id"];
    id = json['id'].toString();
    description = json['description'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    expenseDate = json['expense_date'] ?? "";
    amount = double.parse(json['amount'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description ?? "";
    data['amount'] = this.amount ?? 0;
    data['expense_date'] = this.expenseDateTime != null ? this.expenseDateTime.toString() : this.expenseDate ?? "";
    data['latitude'] = this.latitude ?? "";
    data['longitude'] = this.longitude ?? "";
    return data;
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'ExpenseModel{idLocal: $idLocal, id: $id, description: $description, expenseDate: $expenseDate, latitude: $latitude, longitude: $longitude, amount: $amount, expenseDateTime: $expenseDateTime, isLocal: $isLocal}';
  }
}