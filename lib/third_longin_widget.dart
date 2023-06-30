import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ThirdLoginView extends StatefulWidget {
  const ThirdLoginView({
    Key? key,
    required this.googleCallBack,
    required this.facebookCallBack,
    required this.iosCallBack,
    required this.isIos,
  }) : super(key: key);
  final Function() googleCallBack;
  final Function() facebookCallBack;
  final Function() iosCallBack;
  final bool isIos;

  @override
  State<ThirdLoginView> createState() => _ThirdLoginViewState();
}

class _ThirdLoginViewState extends State<ThirdLoginView> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
          width: MediaQuery.of(context).size.width - 207.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.googleCallBack,
                child: Image.asset(
                  'packages/flutter_third_login/assets/images/google.png',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: widget.facebookCallBack,
                child: Image.asset(
                  'packages/flutter_third_login/assets/images/facebook.png',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              Visibility(
                visible: widget.isIos,
                child:  GestureDetector(
                onTap: widget.facebookCallBack,
                child: Image.asset(
                  'packages/flutter_third_login/assets/images/ios.png',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),)
            ],
          ),
        );
  }
}