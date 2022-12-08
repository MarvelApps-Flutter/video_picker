import 'dart:typed_data';

class Videomodel {
  String name;
  String path;
  Uint8List? thumbnail;
  Videomodel({required this.name, required this.path, this.thumbnail});
}
