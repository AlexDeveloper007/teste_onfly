import 'package:flutter/material.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/Strings.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/widgets/CircleAvatarCache.dart';
import 'package:teste_onfly/widgets/global_button_widget.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DevInfoScreen extends StatefulWidget {
  @override
  _DevInfoScreenState createState() => _DevInfoScreenState();
}

class _DevInfoScreenState extends State<DevInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GlobalTextWidget(
          "Dev Info",
          color: Colors.white,
          fontSize: 16
        ),
      ),
      body: _body(),
    );
  }

  _body(){
    double tamanhoTela = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: tamanhoTela,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatarCache(
              urlImagem: "https://i.imgur.com/XAgiaxX.jpeg",
              size: 144,
            ),
            SizedBox(height: 16,),
            Center(
              child: GlobalTextWidget(
                "Aplicativo desenvolvido por ${Strings.DEV_NAME}",
                color: ColorsUtil.DARK_COLOR,
                fontSize: 16,
                fontFamily: "OpenSans",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async{
                    const url = "${Strings.DEV_LINKEDIN}";
                    if (await canLaunch(url))
                    await launch(url);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Image.asset("assets/images/iconLinkedin.png", height: 40,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    var url = "${Strings.DEV_WPP}";
                    _launchURL(url);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Image.asset("assets/images/iconWpp.png", height: 64,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16,),
            Container(
                margin: EdgeInsets.only(left: 32, right: 32),
                child: GlobalButtonWidget(
                  text: "Voltar",
                  textColor: Colors.white,
                  onPressed: (){
                    frwkNavigator.popNavigate();
                  },
                ),
            ),
            SizedBox(height: 72,),
          ],
        ),
      ),
    );
  }

  _launchURL(url) async => await canLaunch(url)
      ? await launch(url) : throw 'Not found $url';
  //
}
