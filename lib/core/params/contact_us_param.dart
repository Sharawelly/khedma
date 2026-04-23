import 'package:equatable/equatable.dart';

class ContactUsParam extends Equatable {
  final String? title;
  final String? message;
  const ContactUsParam({
    this.title,
    this.message
  });
  Map<String,dynamic>toJson(){
    return{
      'title':title,
      'message':message
    };
  }
  @override
  List<Object?> get props => [];
}
