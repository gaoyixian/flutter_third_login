import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ThirdLoginView extends StatefulWidget {
  const ThirdLoginView({
    Key? key,
    required this.googleCallBack,
    required this.facebookCallBack,
  }) : super(key: key);
  final Function() googleCallBack;
  final Function() facebookCallBack;

  @override
  State<ThirdLoginView> createState() => _ThirdLoginViewState();
}

class _ThirdLoginViewState extends State<ThirdLoginView> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
          width: MediaQuery.of(context).size.width - 264.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.googleCallBack,
                child: Image.asset(
                  'assets/images/google.png',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: widget.facebookCallBack,
                child: Image.asset(
                  'assets/images/facebook.png',
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
  }
}