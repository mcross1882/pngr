import 'dart:io';
import 'package:image/image.dart';

const int BYTE_SIZE = 4;
const int DEFAULT_WIDTH = 200;

/**
 * Takes a file and reads it in as bytes. These
 * are then encoded into an image that is either 200
 * pixels long or the max length possible given the data
 */
void encodeCsvToPng(List<int> bytes, String filename) {
  int pixelCount = bytes.length ~/ BYTE_SIZE;
  int width = pixelCount < DEFAULT_WIDTH ? pixelCount : DEFAULT_WIDTH;
  int height = pixelCount ~/ width;

  if (height <= 0) {
    height = 1;
  }

  Image imageToRender = new Image.fromBytes(width, height, bytes);

  new File(filename).writeAsBytesSync(encodePng(imageToRender));
}

/**
 * Decodes the image data from the PNG image
 */
void decodePngToString(List<int> bytes, String filename) {
  Image image = decodePng(bytes);
  new File(filename).writeAsBytesSync(split4ByteInts(image.data));
}

/**
 * Splits an encoded PNG byte into individual runes (characters)
 */
List<int> split4ByteInts(list) {
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
  if (arguments.length < 2) {
    return print('Syntax: pngr [--decode] [input] [output]');
  }

  bool isEncoding = !arguments.contains('--decode');
  String inputFile = arguments[arguments.length-2];
  String outputFile = arguments[arguments.length-1];

  print("Converting ${inputFile} to ${outputFile}");

  try {
    new File(inputFile).readAsBytes()
    .then((List<int> bytes) {
      isEncoding ? encodeCsvToPng(bytes, outputFile) : decodePngToString(bytes, outputFile);
    });
  } catch (error, stackTrace) {
    print("Caught Exception: ${error}\n${stackTrace}");
  }

  print("Finished!");
}
