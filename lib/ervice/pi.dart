import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class EnPoint extends ChangeNotifier {
  final url = "http://10.0.2.2:4000/upload";
  final urlget = "http://10.0.2.2:4000/api";

  String me = '';
  List<Myresponse> daata = [];
  bool temp = false;
  Future<void> getData() async {
    daata.clear();
    try {
      temp = true;
      notifyListeners();
      final response = await http.get(Uri.parse(urlget), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      final data = Myresponse.fromjson(json.decode(response.body));
      daata.add(data);
      temp = false;
      notifyListeners();
    } catch (e) {
      temp = false;
      notifyListeners();
    }
  }

  void removeImage() {
    daata.clear();
    notifyListeners();
  }

  Future<void> getCl(File file) async {
    final request = http.MultipartRequest("POST", Uri.parse(url));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'image', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path.split("/").last));
    request.headers.addAll(headers);

    final response = await request.send();
    final res = await http.Response.fromStream(response);
    final re = jsonDecode(res.body);
    me = re['message'];
    notifyListeners();
  }
}

class Myresponse extends ChangeNotifier {
  final String image;
  final Map<String, dynamic> location;
  final int itemNumber;

  Myresponse(this.image, this.location, this.itemNumber);
  factory Myresponse.fromjson(Map<String, dynamic> loc) {
    if (loc == null) {
      return null;
    } else {
      return Myresponse(loc["image"] ?? "", loc["location"], loc["object"]);
    }
  }
}
