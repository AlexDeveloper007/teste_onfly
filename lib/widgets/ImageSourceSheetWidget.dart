
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';


class ImageSourceSheetWidget extends StatelessWidget {

  Function(XFile)? onImagemSelecionada;
  Function(File)? onDocumentoSelecionado;
  bool apenasImagem;
  bool mostrarArquivosIos;

  ImageSourceSheetWidget({this.onImagemSelecionada, this.onDocumentoSelecionado, this.apenasImagem = true, this.mostrarArquivosIos = false});
  final ImagePicker _picker = ImagePicker();

  void imagemSelecionada(File imagem, BuildContext context) async{

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagem.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Editar",
            toolbarColor: ColorsUtil.PRIMARY_COLOR,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: ColorsUtil.PRIMARY_COLOR,
            dimmedLayerColor: ColorsUtil.DARK_COLOR,
            backgroundColor: ColorsUtil.DARK_COLOR,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    if(croppedFile != null){
      XFile xFile = XFile(croppedFile.path);
      onImagemSelecionada!(xFile);
    }
    frwkNavigator.popNavigate();
}

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: (){},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async{
                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                if(photo != null){
                  File file = File(photo.path);
                  imagemSelecionada(file, context);
                }
              },
              child: GlobalTextWidget(
                "Câmera",
                color: ColorsUtil.DARK_COLOR,
              ),
            ),
            TextButton(
              onPressed: () async {
                if ( apenasImagem  || (Platform.isIOS && mostrarArquivosIos)) {
                  final XFile? photo = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (photo != null) {
                    File file = File(photo.path);
                    imagemSelecionada(file, context);
                  }
                } else {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
                      if (result != null) {
                        File file = File(result.files.first.path!);
                        imagemSelecionada(file, context);
                      }
                    }
              },
              child: GlobalTextWidget(
                "Galeria",
                color: ColorsUtil.DARK_COLOR,
              ),
            ),
            Platform.isIOS && mostrarArquivosIos ?
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
                if (result != null) {
                  File file = File(result.files.first.path!);
                  imagemSelecionada(file, context);
                }
              },
              child: GlobalTextWidget(
                "Arquivos",
                color: ColorsUtil.DARK_COLOR,
              ),
            ) : ContainerPlus()

          ],
        )
    );
  }
}
