
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:teste_onfly/controller/expense_controller.dart';
import 'package:teste_onfly/model/expense_dao.dart';
import 'package:teste_onfly/model/expense_model.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/date_util.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/util/metodos.dart';
import 'package:teste_onfly/util/snackbar_util.dart';
import 'package:teste_onfly/widgets/ImageSourceSheetWidget.dart';
import 'package:teste_onfly/widgets/alertas.dart';
import 'package:teste_onfly/widgets/datePicker/datepicker_widget.dart';
import 'package:teste_onfly/widgets/global_text_field_widget.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widgets/global_button_widget.dart';

class NewExpenseScreen extends StatefulWidget {
  ExpenseModel? expense;
  NewExpenseScreen({this.expense, Key? key}) : super(key: key);

  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  ExpenseModel? get morador => widget.expense;
  File? _imagemSelecionada;
  final DatepickerController _dtpSelectedDate = DatepickerController();
  DateTime? dataInicial;

  bool _isEdit = false;
  final expenseDao = ExpenseDao();

  final _controllerDescription = TextEditingController(),
      _controllerAmount = TextEditingController();

  String _errorDescription = "";
  String _errorAmount = "";
  String _latitude = "", _longitude = "";

  DateTime selectedDate = DateTime.now();

  final _expenseController = GetIt.I<ExpenseController>();

  _init() async{
    await _expenseController.sendLocalExpenses();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _getLocation();
    _dtpSelectedDate.date = dataInicial;
    if(widget.expense != null){
      _controllerDescription.text = widget.expense!.description!;
      _controllerAmount.text = widget.expense!.amount!.toString();
      DateTime dt ;

      if(widget.expense!.isLocal){
        DateFormat inputFormat = DateFormat('dd-MM-yyyy');
        dt = inputFormat.parse(widget.expense!.expenseDate!);
      }else{
        dt = DateTime.parse(widget.expense!.expenseDate!);
      }

      _dtpSelectedDate.date = dt;
      _isEdit = true;
    }

    _init();
  }

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: _buildAppBar(),
          body: ContainerPlus(
            child: _buildBody(),
          )
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: GlobalTextWidget(
        widget.expense != null ? "Informações despesa" : "Cadastrar despesa",
        color: Colors.grey[600],
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () {
          frwkNavigator.popNavigate();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.grey[600],
        ),
      ),
      actions: [
        _isEdit ?
        ContainerPlus(
          onTap: (){
            alertaDelete(context,
                      titulo: "Excluir despesa",
                      msg:
                          "Deseja confirmar a exclusão de ${widget.expense!.description!}?",
                      funcExcluir: () async{
                        if(widget.expense!.isLocal){
                          expenseDao.delete(widget.expense!.idLocal!);
                        }else{
                          if(!await Metodos.hasNetwork()) {
                            return SnackbarUtil.snackError(
                                "Sem conexão com a internet!");
                          }else{
                            await _expenseController.deleteExpense(widget.expense!);
                          }
                        }
                        frwkNavigator.popNavigate();
                      });
                },
          margin: EdgeInsets.only(right: 4),
          isCenter: true,
          child: GlobalTextWidget("Excluir", color: Colors.red,),
        ) : ContainerPlus()
      ],
    );
  }

  _buildBody() {
    return
      Observer(
        builder: (_){
          return ListView(
            padding: EdgeInsets.only(top: 30, left: 16, right: 16),
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  GlobalTextWidget(
                      "Adicione uma foto",
                      fontSize: 16,
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400),
                  ContainerPlus(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => ImageSourceSheetWidget(
                            apenasImagem: true,
                            onImagemSelecionada:
                                (imagemSelecionada) async {
                              File imageFile =
                              File(imagemSelecionada.path);

                              setState(() {
                                _imagemSelecionada = imageFile;
                              });
                            },
                          ));
                    },
                    height: 126,
                    margin: EdgeInsets.only(bottom: 32),
                    child:
                    _imagemSelecionada != null
                        ? Center(
                      child: ContainerPlus(
                          height: 128,
                          color: ColorsUtil.PRIMARY_COLOR,
                          radius: RadiusPlus.all(16),
                          child: Image.file(_imagemSelecionada!)),
                    )
                        : Stack(
                      children: [
                        Align(
                            child: ContainerPlus(
                                width: 113,
                                height: 113,
                                child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 45,
                                    color: Colors.grey[100]),
                                color: Colors.grey[300],
                                radius: RadiusPlus.all(20)),
                            alignment: Alignment.topCenter),
                      ],
                    ),
                  ),
                  GlobalTextFieldWidget(
                    margin: EdgeInsets.only(bottom: 24),
                    required: true,
                    label: "Descrição",
                    controller: _controllerDescription,
                    errorMessage: _errorDescription,
                    placeholder: "Informe a descrição",
                    onChanged: (text) {
                      setState(() {
                        if (_errorDescription.isNotEmpty && text.isNotEmpty) {
                          _errorDescription = '';
                        }
                      });
                    },
                  ),
                  GlobalTextFieldWidget(
                    margin: EdgeInsets.only(bottom: 24),
                    required: true,
                    label: "Valor",
                    controller: _controllerAmount,
                    errorMessage: _errorAmount,
                    textInputType: TextInputType.number,
                    placeholder: "Informe o valor da despesa",
                    onChanged: (text) {
                      setState(() {
                        if (_errorAmount.isNotEmpty && text.isNotEmpty) {
                          _errorAmount = '';
                        }
                      });
                    },
                  ),
                  DatepickerWidget(
                      key: Key('dtpDataInicial'),
                      controller: _dtpSelectedDate,
                      //margin: ,
                      label: "Data*",
                      placeholder: "Selecione a data",
                      dataType: DateUtil.DATA_INICIAL,
                      onSelect: () {
                        setState(() {
                          //_boletosController.dataInicial = _dtpDataInicial.date;
                        });
                      }
                  ),
                  SizedBox(height: 16,),
                  GlobalButtonWidget(
                      margin: EdgeInsets.all(16),
                      backgroundColor: ColorsUtil.PRIMARY_COLOR,
                      textColor: Colors.white,
                      loading: _expenseController.loading,
                      text: widget.expense != null ? "Salvar alterações" : "Cadastrar despesa",
                      onPressed: () async{
                        if(_validarDados()) {
                          if(!_isEdit){
                            widget.expense = ExpenseModel();
                          }
                          widget.expense!.description = _controllerDescription.text;
                          widget.expense!.amount = double.parse(_controllerAmount.text);
                          widget.expense!.expenseDate = Metodos.getDataHoraString(_dtpSelectedDate.date);
                          widget.expense!.expenseDateTime = _dtpSelectedDate.date;
                          widget.expense!.latitude = _latitude;
                          widget.expense!.longitude = _longitude;

                          if(widget.expense!.isLocal && _isEdit){
                            expenseDao.update(widget.expense!);

                            _expenseController.expenseList.indexWhere((element) {
                              if (element.id == widget.expense!.id) {
                                widget.expense!.isLocal = true;
                                int index = _expenseController.expenseList.indexOf(element);
                                _expenseController.updateExpenseList(index, widget.expense!);
                              }
                              return element.id == widget.expense!.id;
                            });
                            SnackbarUtil.snackSucesso("Despesa editada com sucesso!");
                          }else if(!_isEdit && !await Metodos.hasNetwork()){
                            widget.expense!.isLocal = true;
                            expenseDao.save(widget.expense!);
                            _expenseController.expenseList.add(widget.expense!);
                            SnackbarUtil.snackSucesso("Despesa criada com sucesso!");
                          }else{
                            if(_isEdit){
                              if(!await Metodos.hasNetwork()){
                                SnackbarUtil.snackError("Sem conexão com a internet!");
                              }else{
                                await _expenseController.updateExpense(widget.expense!);
                              }
                            }else{
                              if(!await Metodos.hasNetwork()){
                                SnackbarUtil.snackError("Sem conexão com a internet!");
                              }else{
                                await _expenseController.createExpense(widget.expense!);
                              }
                            }
                          }
                          frwkNavigator.popNavigate();
                        }
                      }),
                ],
              )
            ],
          );
        },
      );
  }


  bool _validarDados(){
    _errorDescription = "";
    _errorAmount = "";
    if(_controllerDescription.text.trim().isEmpty){
      _errorDescription = "Digite uma descrição!";
    }

    if(_controllerAmount.text.trim().isEmpty){
      _errorAmount = "Digite um valor!";
    }

    setState(() {});
    if(_errorDescription.trim().isNotEmpty || _errorAmount.trim().isNotEmpty || _dtpSelectedDate.date == null){
      return SnackbarUtil.snackError("Preencha todos os campos obrigatórios");
    }else{
      return true;
    }
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _latitude = position.latitude.toString();
    _longitude = position.longitude.toString();
  }

}
