import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id_upgrade/platform_device_id.dart';

class Utils {
  static void fireToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};
    var getDeviseId = await PlatformDeviceId.getDeviceId;
    String fmcToken = '';

    if (Platform.isIOS) {
      params.addAll({
        'deviceId': getDeviseId.toString(),
        'deviceType': 'I',
        'deviceToken': fmcToken,
      });
    } else {
      params.addAll({
        'deviceId': getDeviseId.toString(),
        'deviceType': 'A',
        'deviceToken': fmcToken,
      });
    }
    return params;
  }

  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString()}:${now.minute.toString().padLeft(2, '0')}";
    return convertedDateTime;
  }

  static Future<bool?> dialogCommon(BuildContext context, String title, String message, bool isSingle)async{
    return await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          !isSingle ?
          MaterialButton(
           onPressed: (){
             Navigator.of(context).pop(null);
           },
            child: const Text('Cancel'),
          ) : const SizedBox.shrink(),
          MaterialButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirm'),
          )
        ],
      );

    });
  }

}
