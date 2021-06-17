import 'package:flutter/material.dart';
import 'package:motion/models/image.dart';
import 'package:provider/provider.dart';
import '../provider/images.dart';

class DetailScreen extends StatelessWidget {
  static const routName = '/Detail_Screen';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    // String IMG = context.read()<Images>().items.where(id;
    print(routeArgs);
    return Scaffold(
      appBar: AppBar(
        title: Text('photo'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(routeArgs as String),
      ),
    );
  }
}
