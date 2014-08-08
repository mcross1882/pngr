import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart';

void encodeCsvToPng(List<int> bytes, String filename) {
  int width = 20;
  int height = bytes.length ~/ 200;

  if (height <= 0) {
    height = 1;
  }

  Image imageToRender = new Image.fromBytes(width, height, bytes);

  new File(filename).writeAsBytesSync(encodePng(imageToRender));
}

void decodePngToString(List<int> bytes, String filename) {
  Image image = decodePng(bytes);

  print(UTF8.decode(split4ByteInt(image.data)));
}

List<int> split4ByteInt(list) {
  var result = new List<int>();
  list.forEach((byte) {
    result.addAll([
       byte & 0xFF,
      (byte >> 8) & 0xFF,
      (byte >> 16) & 0xFF,
      (byte >> 24) & 0xFF,
    ]);
  });

  return result;
}

void main(List<String> arguments) {
  if (arguments.length < 3) {
    return print('Syntax: pnr [-d] [input] [output]');
  }

  bool isEncoding = !arguments.contains('-d');
  String inputFile = arguments[arguments.length-2];
  String outputFile = arguments[arguments.length-1];

  if (isEncoding) {
    new File(inputFile).readAsBytes()
      .then((List<int> bytes) => encodeCsvToPng(bytes, outputFile));
  } else {
    new File(inputFile).readAsBytes()
      .then((List<int> bytes) => decodePngToString(bytes, outputFile));
  }

  print("Finished!");
}
