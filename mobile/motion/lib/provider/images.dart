import 'dart:io';

import 'package:provider/provider.dart';
import '../models/image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Images with ChangeNotifier {
  List<MyImage> _items = [];

  List<MyImage> get items {
    return [..._items];
  }

  Future<void> fetchAndSetimages() async {
    final url = Uri.https('shielded-fjord-30824.herokuapp.com', '/api');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      final List<MyImage> loadedImages = [];
      extractedData.forEach((img) {
        loadedImages
            .add(MyImage(img['id'].toString(), img['image_url'].toString()));
      });
      _items = loadedImages;
      print(_items);

      notifyListeners();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
}
