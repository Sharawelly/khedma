import 'package:equatable/equatable.dart';

class PostReturnsSalaParams extends Equatable {
  final double? discount;
  final double? percentDiscount;
  final List<OrderItem>? orderItems;

  const PostReturnsSalaParams({
    this.discount,
    this.percentDiscount,
    this.orderItems,
  });
  //create toJson method
  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'discount_percentage': percentDiscount,
      'items': orderItems
          ?.map((item) => {
                'item_id': item.itemId,
                'quantity': item.quantity,
              })
          .toList(),
    };
  }

  @override
  List<Object> get props => [
        orderItems ?? const [],
      ];

  @override
  bool get stringify => true;
}

class OrderItem extends Equatable {
  final int itemId;
  final int quantity;
  const OrderItem(this.itemId, this.quantity);
  @override
  List<Object> get props => [itemId, quantity];
}
