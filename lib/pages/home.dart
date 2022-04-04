import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/db_services.dart';
import 'package:shopping_cart_flutter/models/shopping_cart.dart';
import 'package:shopping_cart_flutter/pages/cart.dart';
import 'package:shopping_cart_flutter/shopping_cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DBServices? dbServices=DBServices();

  List<String> productName = [
    'Apple',
    'Banana',
    'Grapes',
    'Mango',
    'Orange',
    'Strawberry',
    'Watermelon',
  ];

  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'images/apple.jpg',
    'images/banana.jpg',
    'images/grapes.jpg',
    'images/mango.jpg',
    'images/orange.jpg',
    'images/strawberry.jpg',
    'images/watermelon.jpg',];

  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<ShoppingCartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Fruits Store'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ShoppingCartPage()));
            },
            child: Center(
              child: Badge(
                badgeContent:Consumer<ShoppingCartProvider>(
                builder: (context, value, child) {
                  return Text(
                   value.getCounter().toString() ,
                    style: TextStyle(color: Colors.white),
                  );
                }),
                animationDuration: const Duration(milliseconds: 300),
                child: Container(child: const Icon(Icons.shopping_cart)),
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  image: AssetImage(productImage[index]),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(productName[index],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                      Text(
                                          '\$ ${productPrice[index]} / ${productUnit[index]}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10,),
                                      Align(
                                        alignment: Alignment.centerRight ,
                                        child: InkWell(
                                          onTap: (){
                                            dbServices!.insert(
                                              ShoppingCart(id: index, productId: index.toString(), productName: productName[index], initialPrice: productPrice[index], productPrice: productPrice[index], quantity: 1, unitTag: productUnit[index], image: productImage[index])
                                            ).then((value) {
                                              print('Product is added to cart');
                                              cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cart.addCounter();
                                            }).onError((error, stackTrace){
                                              print(error.toString());
                                            });
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Center(child: Text('Add to cart',style: TextStyle(color: Colors.white) ,)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })),
          Consumer<ShoppingCartProvider>(builder: (context, value, child) {
            return Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total : \$${value.totoalPrice}",style: Theme.of(context).textTheme.subtitle1,)
                ],
              ),
            );
          }
          )
          
        ],
      ),
    );
  }
}
