import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StreamBuilderWidget extends StatefulWidget {
  const StreamBuilderWidget({super.key});

  @override
  State<StreamBuilderWidget> createState() => _StreamBuilderWidgetState();
}

class _StreamBuilderWidgetState extends State<StreamBuilderWidget> {
  List<String> list = [];
  StreamsSocket streamSocket = StreamsSocket();
  TextEditingController messageController = TextEditingController();

  Stream<DateTime> generateNumber() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.add("Umer");
    streamSocket.addResponse(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Streams"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
              stream: streamSocket.getResponse,
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  return Center(
                    child: Text(
                      snapshot.data.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Text(snapshot.data![index].toString());
                      });
                } else {
                  return Text("Something went wrong");
                }
              }),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    list.add(messageController.text.toString());
                    streamSocket.addResponse(list);
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class StreamsSocket {
  final _stream = StreamController<List<String>>.broadcast();
  void Function(List<String>) get addResponse => _stream.sink.add;
  Stream<List<String>> get getResponse => _stream.stream.asBroadcastStream();
}
