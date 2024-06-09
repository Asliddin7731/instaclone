import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';

class Utils {
  static void fireToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static Future<Map<String, String>> deviceParams() async{
    Map<String, String> params = {};
    var getDeviseId = await PlatformDeviceId();
    String fmcToken = '';

    if(Platform.isIOS){
      params.addAll({
        'deviceId' : getDeviseId.toString(),
        'deviceType' : 'I',
        'deviceToken' : fmcToken,

      });
    } else{
      params.addAll({
        'deviceId' : getDeviseId.toString(),
        'deviceType' : 'A',
        'deviceToken' : fmcToken,

      });
    }
    return params;
  }

}