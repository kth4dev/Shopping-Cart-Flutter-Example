class ShoppingCart {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  ShoppingCart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image
});


  ShoppingCart.fromMap(Map<dynamic,dynamic> res):
        id = res['id'],
        productId=res["productId"],
        productName=res["productName"],
        initialPrice=res["initialPrice"],
        productPrice=res["productPrice"],
        quantity=res["quantity"],
        unitTag=res["unitTag"],
        image=res["images"];

  Map<String,Object?> toMap(){
    return {
      'id':id,
      'productId':productId,
      'productName':productName,
      'initialPrice':initialPrice,
      'productPrice':productPrice,
      'quantity':quantity,
      'unitTag':unitTag,
      'images':image,
    };
  }



}
