
import 'package:flutter/material.dart';

class CircleAvatarCache extends StatelessWidget {

  String urlImagem;
  double size;
  CircleAvatarCache({required this.urlImagem, required this.size});

  @override
  Widget build(BuildContext context) {

    if(urlImagem == null ){
      return CircleAvatar(
        radius: 24,
        child: Image.asset("assets/imagens/avatar.png"),
        backgroundColor: Colors.transparent,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
        border: new Border.all(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      child: ClipOval(
          child: Image.network(
            urlImagem,
          ),
      ),
    );

  }
}