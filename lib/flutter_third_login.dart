
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_third_login/third_longin_widget.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;

typedef MathCallback = void Function(String method, dynamic arguments);

class FlutterThirdLogin {
  static const MethodChannel _channel = MethodChannel('flutter_third_login');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //----------------------------微信登陆相关-----------------
  static get registerWxApi
  {
    return fluwx.registerWxApi;
  }

  static get isWeChatInstalled
  {
    return fluwx.isWeChatInstalled;
  }

  static get sendWeChatAuth
  {
    return fluwx.sendWeChatAuth;
  }

  static get weChatResponseEventHandler
  {
    return fluwx.weChatResponseEventHandler;
  }

  static Type get weChatAuthResponse
  {
    return fluwx.WeChatAuthResponse;
  }

  static isWeChatAuthResponseType(response)
  {
    return response is fluwx.WeChatAuthResponse;
  }

  //----------------------------ios登陆相关--------------
  static init(MathCallback callback)
  { 
    _channel.setMethodCallHandler((call)async{
      callback(call.method, call.arguments);
    });
  }

  static Future<void> iosLogin() async {
    _channel.invokeMethod('iosLogin');

  }

  static Future<bool> allowIosLogin() async {
    var result =  await _channel.invokeMethod('allowIosLogin');
    return result == 'true';
  }
  
  //----------------------------第三方登陆相关--------------
  Widget getThirdLoginView(
    BuildContext context, {
    required void Function() gooCallBack,
    required void Function() faceCallBack,
  }) {
    return ThirdLoginView(
        googleCallBack: gooCallBack, facebookCallBack: faceCallBack);
  }
}
