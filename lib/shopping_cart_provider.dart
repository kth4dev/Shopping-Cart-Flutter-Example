import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_flutter/db_services.dart';

import 'models/shopping_cart.dart';

class ShoppingCartProvider with ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0 ;
  double get totoalPrice => _totalPrice;
  
  DBServices db=DBServices();

   void _setPrefItem() async{
     SharedPreferences prefes= await SharedPreferences.getInstance();
         prefes.setInt("cart_item", _counter);
        prefes.setDouble("total_price", _totalPrice);
        notifyListeners();
   }
   
   void _getPrefItem() async{
     SharedPreferences prefs= await SharedPreferences.getInstance();
     _counter = prefs.getInt("cart_item") ?? 0;
     _totalPrice=prefs.getDouble("total_price") ?? 0.0;
     notifyListeners();
   }

   void addCounter(){
     _counter++;
     _setPrefItem();
     notifyListeners();
   }
  void removeCounter(){
    _counter--;
    _setPrefItem();
    notifyListeners();
  }

  int getCounter (){
      _getPrefItem();
      return _counter;
  }

  void addTotalPrice(double productPrice){
    _totalPrice=_totalPrice+productPrice;
    _setPrefItem();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice){
    _totalPrice=_totalPrice-productPrice;
    _setPrefItem();
    notifyListeners();
  }

  double getTotalPrice (){
    _getPrefItem();
    return _totalPrice;

  }

  late Future<List<ShoppingCart>> _cart;

   Future<List<ShoppingCart>> getData() async{
     _cart=db.getCartList();
         return _cart;
   }


}