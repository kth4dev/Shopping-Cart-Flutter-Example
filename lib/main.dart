import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/shopping_cart_provider.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
       create:(_) => ShoppingCartProvider(),
        child: Builder(builder: (BuildContext context){
          return MaterialApp(
            title: 'Shopping Cart Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomePage(),
          );
        }
        )
   );
  }
}

