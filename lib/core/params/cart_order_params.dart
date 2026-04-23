import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class CartOrderParams extends Equatable {
  final List<int> itemsIds;
  final String orderType;
  final String? representCode;
  final String notes;
  final String? promoCodeId;
  final List<int> itemsQuantities;
  final String orderStatusId;

  const CartOrderParams({
    required this.itemsIds,
    required this.orderType,
    required this.representCode,
    required this.notes,
    this.promoCodeId,
    required this.itemsQuantities,
    required this.orderStatusId,
  });

  /// Converts the order parameters to FormData format for multipart requests
  FormData toFormData() {
    final formData = FormData();

    // Add array parameters with proper [] syntax
    _addArrayField(formData, 'items[]', itemsIds);
    _addArrayField(formData, 'required_quantity[]', itemsQuantities);

    // Add other fields with validation
    formData.fields.addAll([
      MapEntry('order_type', orderType),
      MapEntry('represent_code', representCode??''),
      MapEntry('notes', notes),
      if (promoCodeId != null && promoCodeId!.isNotEmpty)
        MapEntry('promo_code_id', promoCodeId!),
      MapEntry('order_status_id', orderStatusId),
    ]);

    return formData;
  }

  /// Helper method to add array fields to FormData
  void _addArrayField(FormData formData, String fieldName, List<int> values) {
    for (final value in values) {
      formData.fields.add(MapEntry(fieldName, value.toString()));
    }
  }



  @override
  List<Object?> get props => [
        itemsIds,
        orderType,
        representCode,
        notes,
        promoCodeId,
        itemsQuantities,
        orderStatusId,
      ];
}