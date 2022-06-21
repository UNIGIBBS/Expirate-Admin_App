import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:mobile_scanner/mobile_scanner_web_plugin.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  ImagePickerPlugin.registerWith(registrar);
  MobileScannerWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
