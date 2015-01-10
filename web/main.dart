// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'dart:convert';


void main() {
  querySelector('#output').text = 'Dart is running.';
  
  Myo myo = new Myo();
}


class Myo {
  
  static int api_version = 3;
  static String socket_url = "ws://127.0.0.1:10138/myo/";
  
  List events;
  List myos;
  
  WebSocket ws;
  
  bool isLocked;
  bool isConnected;
  
  Map orientationOffset = { 'x' : 0,
                            'y' : 0,
                            'z' : 0,
                            'w' : 0
                            };
  
  var lastIMU;
  var arm; 
  var direction;
  
  Myo() {
    ws = initWebSocket();
  }

  WebSocket initWebSocket([int retrySeconds = 2]) {
    var reconnectScheduled = false;

    print("Connecting to websocket");
    WebSocket ws = new WebSocket(socket_url + api_version.toString());

    void scheduleReconnect() {
      if (!reconnectScheduled) {
        new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
      }
      reconnectScheduled = true;
    }

    ws.onOpen.listen((e) {
      print('Connected');
      ws.send('Hello from Dart!');
    });

    ws.onClose.listen((e) {
      print('Websocket closed, retrying in $retrySeconds seconds');
      scheduleReconnect();
    });

    ws.onError.listen((e) {
      print("Error connecting to ws");
      scheduleReconnect();
    });

    ws.onMessage.listen((MessageEvent e) {
     handleMessage(e.data);
    });
    
    return ws;
  }

  
  void handleMessage(String e){
    List data = JSON.decode(e);
    print(data);
  }
 

  
}