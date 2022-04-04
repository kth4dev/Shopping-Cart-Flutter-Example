import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db_services.dart';
import '../models/shopping_cart.dart';
import '../shopping_cart_provider.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {

  DBServices? dbServices=DBServices();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<ShoppingCartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
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
          const SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
              builder: (context, AsyncSnapshot<List<ShoppingCart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Column(
                    children: [
                      Image(image: AssetImage("images/shopping_cart.png"),
                      width: 200,height: 200,),
                      Center(child: Text('Cart is empty!',style: TextStyle(
                        fontSize: 20,
                      ),)),
                    ],
                  );
                }else{
                  return  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
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
                                          image: AssetImage(snapshot.data![index].image.toString()),
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
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(snapshot.data![index].productName.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500)),
                                                  InkWell(
                                                      onTap: (){
                                                        dbServices!.delete(snapshot.data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(snapshot.data![index].productPrice!.toDouble());
                                                      },
                                                      child: Icon(Icons.delete))
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                  '\$ ${snapshot.data![index].initialPrice} / ${snapshot.data![index].unitTag }',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 10,),
                                              Align(
                                                  alignment: Alignment.centerRight ,
                                                  child: Container(
                                                    width: 100,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(child: Icon(Icons.remove,color: Colors.white,),
                                                            onTap: (){
                                                              if(snapshot.data![index].quantity!>0){
                                                                int qty=snapshot.data![index].quantity!-1;
                                                                int price=snapshot.data![index].initialPrice!;
                                                                int newPrice=qty*price;
                                                                dbServices?.updateQuantity(
                                                                    ShoppingCart(id: snapshot.data![index].id!,
                                                                        productId: snapshot.data![index].productId!,
                                                                        productName:snapshot.data![index].productName!,
                                                                        initialPrice:snapshot.data![index].initialPrice!,
                                                                        productPrice:newPrice,
                                                                        quantity: qty,
                                                                        unitTag: snapshot.data![index].unitTag!,
                                                                        image: snapshot.data![index].image!)
                                                                ).then((value) {
                                                                  newPrice=0;
                                                                  qty=0;
                                                                  cart.removeTotalPrice(snapshot.data![index].initialPrice!.toDouble());
                                                                  print("updated");
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                              }
                                                            },),
                                                          Center(child: Text(snapshot.data![index].quantity.toString(),style: TextStyle(color: Colors.white) ,)),
                                                          InkWell(
                                                            child: Icon(Icons.add,color: Colors.white,),
                                                            onTap: (){
                                                              int qty=snapshot.data![index].quantity!+1;
                                                              int price=snapshot.data![index].initialPrice!;
                                                              int newPrice=qty*price;
                                                              dbServices?.updateQuantity(
                                                                  ShoppingCart(id: snapshot.data![index].id!,
                                                                      productId: snapshot.data![index].productId!,
                                                                      productName:snapshot.data![index].productName!,
                                                                      initialPrice:snapshot.data![index].initialPrice!,
                                                                      productPrice:newPrice,
                                                                      quantity: qty,
                                                                      unitTag: snapshot.data![index].unitTag!,
                                                                      image: snapshot.data![index].image!)
                                                              ).then((value) {
                                                                newPrice=0;
                                                                qty=0;
                                                                cart.addTotalPrice(snapshot.data![index].initialPrice!.toDouble());
                                                                print("updated");
                                                              }).onError((error, stackTrace) {
                                                                print(error.toString());
                                                              });
                                                            },
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  )
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
                          })
                  );
                }

              }
                return Text('');
          }),
          Consumer<ShoppingCartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2)=="0.00" ? false:true,
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total : \$${value.totoalPrice}",style: Theme.of(context).textTheme.subtitle1,)
                  ],
                ),
              ),
            );
          }
          )
        ],
      ),
    );
  }
}
