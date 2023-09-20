import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:teste_onfly/controller/expense_controller.dart';
import 'package:teste_onfly/model/expense_model.dart';
import 'package:teste_onfly/screens/home_drawer.dart';
import 'package:teste_onfly/screens/login_screen.dart';
import 'package:teste_onfly/screens/new_expense_screen.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/util/metodos.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _expenseController = GetIt.I<ExpenseController>();

  _init() async{
    await _expenseController.sendLocalExpenses();
    await _expenseController.init();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: Icon(Icons.add),
          backgroundColor: ColorsUtil.PRIMARY_COLOR,
          onPressed: (){
            frwkNavigator.navigate(NewExpenseScreen());
          }
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset(height: 144, width: 144,
          'assets/images/onfly.png',
          fit: BoxFit.contain
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu_rounded, color: ColorsUtil.PRIMARY_COLOR,),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        ContainerPlus(
          onTap: (){
            frwkNavigator.navigate(LoginScreen(), replace: true);
          },
          margin: EdgeInsets.only(right: 8),
          isCenter: true,
          child: GlobalTextWidget(
            "Logout",
          ),
        )
      ],
    );
  }


  _buildBody() {
    return Observer(
        builder: (_) {
          return ContainerPlus(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16),
              itemCount: _expenseController.expenseList.length,
              itemBuilder: (context, index) {
                ExpenseModel expense = _expenseController.expenseList[index];
                return _buildExpenseCard(expense);
              },
            ),
          );
        }
    );
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    DateTime dateTime;
    if(expense.isLocal){
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      dateTime = inputFormat.parse(expense.expenseDate!);
    }else{
      dateTime = DateTime.parse(expense.expenseDate!);
    }

    return ContainerPlus(
      onTap: (){
        frwkNavigator.navigate(NewExpenseScreen(expense: expense));
      },
        color: Colors.white,
        radius: RadiusPlus.all(10),
        shadows: [ShadowPlus(moveDown: 1, spread: 1.0, color: ColorsUtil.GREY_COLOR.withOpacity(0.25))],
        border: BorderPlus(width: 1, color: ColorsUtil.GREY_COLOR),
        padding: EdgeInsets.only(top: 24, bottom: 16, right: 16, left: 16),
        margin: EdgeInsets.only(bottom: 16, right: 16, left: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GlobalTextWidget(
                  '${expense.description}',
                  color: Colors.grey[700],
                  fontSize: 20,
                  margin: EdgeInsets.only(bottom: 16),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                    GlobalTextWidget(
                      "${Metodos.getDataString(dateTime)}",
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      padding: EdgeInsets.only(left: 8),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                    Expanded(
                      child: GlobalTextWidget(
                        "${Metodos.getHoraString(dateTime)}",
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        padding: EdgeInsets.only(left: 8),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                    GlobalTextWidget(
                      Metodos.getStringPreco(expense.amount ?? 0, context),
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      padding: EdgeInsets.only(left: 8),
                    )
                  ],
                ),
                SizedBox(height: 12),
                expense.isLocal ? Row(
                  children: [
                    Icon(
                      Icons.signal_wifi_connected_no_internet_4_rounded,
                      color: Colors.red.withOpacity(0.5), size: 22,),
                    GlobalTextWidget(
                      "Aguardando conexão",
                      color: Colors.red.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      padding: EdgeInsets.only(left: 8),
                    )
                  ],
                ) : ContainerPlus()
              ]),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400],)
          ],
        ));
  }

}
