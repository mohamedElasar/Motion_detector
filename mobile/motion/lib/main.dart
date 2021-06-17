import 'package:flutter/material.dart';
import 'package:motion/provider/images.dart';
import 'package:motion/screens/detailScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Images(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
            DetailScreen.routName: (ctx) => DetailScreen(),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isloading = false;
  var _isinit = true;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });

      Provider.of<Images>(context).fetchAndSetimages().then((_) => {
            setState(() {
              _isloading = false;
            })
          });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<Images>().fetchAndSetimages();
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(
                          DetailScreen.routName,
                          arguments:
                              context.read<Images>().items[index].image_url,
                        )
                        .then((value) => null);
                    setState(() {});
                  },
                  child: ImageTile(
                    index: index,
                  ),
                );
              },
              itemCount: context.read<Images>().items.length,
            ),
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.image),
        trailing: Text(
          "open",
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
        title: Text("photo number ${context.read<Images>().items[index].id}"));
  }
}
