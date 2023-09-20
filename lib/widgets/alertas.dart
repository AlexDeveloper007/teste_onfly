import 'package:flutter/material.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';
alertaDelete(context, {required titulo, required msg, required VoidCallback funcExcluir, Color? corTitulo, String? txtConfirmar, bool closeDialog = true}){
  corTitulo = corTitulo ?? Colors.red;
  Widget naoButton = TextButton(
    child: GlobalTextWidget(
      txtConfirmar ?? "Sim, excluir!",
      color: Colors.red,
    ),
    onPressed: () {
      funcExcluir();
      if(closeDialog){
        Navigator.pop(context);
      }
    },
  );
  Widget simButton = TextButton(
    child:  GlobalTextWidget(
      'Não',
      color: ColorsUtil.DARK_COLOR,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: Row(
      children: [
        Icon(Icons.error_outline, color: ColorsUtil.DARK_COLOR,),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: GlobalTextWidget(
            titulo,
            fontSize: 18,
            color: corTitulo,
            //fontWeight: FontWeight.bold,
          ))
      ],
    ),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlobalTextWidget(
          msg,
          fontSize: 14,
          color: ColorsUtil.DARK_COLOR,
          //fontWeight: FontWeight.bold,
        ),
      ],
    ),
    actions: [
      simButton,
      naoButton,
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

