
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';
import 'global.dart';

class DialogUtil {

  static showErrorI18n(String msg, {String? titulo, String? svg, dynamic msgParamI18n}) {
    showError(msg, titulo: titulo, isI18n: true, msgParamI18n: msgParamI18n, svg: svg!);
  }

  static showError(String msg, {String? titulo, BoxFit boxFit = BoxFit.fill, double? height, String svg = 'assets/svg/img_erro.svg', bool isI18n = false, dynamic msgParamI18n}) {
    dialogPlus.show(
        radius: RadiusPlus.all(10),
        child: StatefulBuilder(
          builder: (context, setState) {
          return Column(
            children: [
              ContainerPlus(
                margin: EdgeInsets.only(top: 10, right: 10),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.grey[600],
                  onPressed: () {
                    frwkNavigator.popNavigate();
                  },
                ),
                alignment: Alignment.topRight,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    svg,
                    fit: boxFit,
                    width: 120,
                    height: 120
                    ),
                  SizedBox(
                    height: 31,
                  ),
                  GlobalTextWidget(
                    titulo ?? "Error",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GlobalTextWidget(
                    msg,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    textAlign: TextAlign.center,
                    margin: EdgeInsets.symmetric(horizontal: 29),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              )
            ],
          );
        }
      )
    );
  }
}
