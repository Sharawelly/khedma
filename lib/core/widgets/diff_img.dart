// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '/core/utils/constants.dart';
// import '/core/utils/values/svg_manager.dart';
// import '/core/utils/values/text_styles.dart';
// import '/injection_container.dart';

// class DiffImage extends StatelessWidget {
//   final dynamic image;
//   final dynamic height;
//   final dynamic width;
//   final dynamic onClick;
//   final dynamic fitType;
//   final dynamic radius;
//   final bool isExpand;
//   final bool hasBorder;
//   final bool hasShadow;
//   final Function? onUserTap;
//   final BorderRadius? borderRadius;
//   final bool isCircle;
//   final String? userName;
//   final Color? userNameColor;
//   final EdgeInsetsGeometry? padding;

//   const DiffImage({
//     super.key,
//     this.image,
//     this.height,
//     this.width,
//     this.radius = 5.0,
//     this.isExpand = true,
//     this.onClick = true,
//     this.hasBorder = false,
//     this.onUserTap,
//     this.fitType = BoxFit.fill,
//     this.hasShadow = false,
//     this.borderRadius,
//     this.isCircle = false,
//     this.userName,
//     this.userNameColor,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       padding: hasBorder ? padding ?? EdgeInsets.all(8.w) : null,
//       decoration: BoxDecoration(
//         borderRadius: borderRadius ?? BorderRadius.circular(radius),
//         border: hasBorder ? Border.all(color: colors.textColor) : null,
//         boxShadow:
//             hasShadow == true
//                 ? const [
//                   BoxShadow(
//                     color: Color.fromRGBO(0, 0, 0, 0.5),
//                     blurRadius: 8.0,
//                     spreadRadius: 0.0,
//                     offset: Offset(0, 2.0),
//                   ),
//                 ]
//                 : [],
//       ),
//       child:
//           Uri.tryParse(image)?.hasAbsolutePath == true
//               ? ClipRRect(
//                 borderRadius: borderRadius ?? BorderRadius.circular(radius),
//                 child: CachedNetworkImage(
//                   placeholder:
//                       (context, url) => Container(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: colors.textColor,
//                           ),
//                         ),
//                       ),
//                   imageUrl: image,
//                   fit: fitType,
//                   memCacheHeight: 320.cacheSize(context),
//                   memCacheWidth: 250.cacheSize(context),
//                   errorWidget:
//                       (context, url, error) => Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(radius),
//                             border: Border.all(color: colors.textColor),
//                           ),
//                           padding: EdgeInsets.all(16.r),
//                           child: SvgPicture.asset(
//                             SvgAssets.notFound,
//                             colorFilter: ColorFilter.mode(
//                               colors.textColor,
//                               BlendMode.srcIn,
//                             ),
//                             fit: BoxFit.scaleDown,
//                           ),
//                         ),
//                       ),
//                 ),
//               )
//               : ClipRRect(
//                 borderRadius: borderRadius ?? BorderRadius.circular(radius),
//                 child: Container(
//                   decoration:
//                       isCircle
//                           ? BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:
//                                 userName == null
//                                     ? null
//                                     : userNameColor ?? colors.main,
//                           )
//                           : null,
//                   padding: EdgeInsets.all(
//                     width != double.infinity ? (width * 0.2) : 10.r,
//                   ),
//                   width: width * 0.6,
//                   height: height * 0.6,
//                   color:
//                       isCircle
//                           ? null
//                           : userName == null
//                           ? null
//                           : userNameColor ?? colors.main,
//                   child:
//                       userName == null
//                           ? SvgPicture.asset(
//                             SvgAssets.notFound,
//                             colorFilter: ColorFilter.mode(
//                               colors.textColor,
//                               BlendMode.srcIn,
//                             ),
//                           )
//                           : Center(
//                             child: Text(
//                               Constants.getInitials(userName ?? ''),
//                               style: TextStyles.bold16(
//                                 color:
//                                     userNameColor == null
//                                         ? Colors.black
//                                         : colors.main,
//                               ),
//                             ),
//                           ),
//                 ),
//               ),
//     );
//   }
// }

// extension ImageExtension on num {
//   int cacheSize(BuildContext context) {
//     return (this * MediaQuery.of(context).devicePixelRatio).round();
//   }
// }
