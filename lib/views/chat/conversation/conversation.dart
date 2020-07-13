import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/components/chat_bubble.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/chat_service.dart';
import 'package:social_app_ui/util/data.dart';

class Conversation extends StatefulWidget {
  final String userId;

  Conversation({@required this.userId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  static Random random = Random();
  String name = names[random.nextInt(10)];

  FocusNode focusNode = FocusNode();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        titleSpacing: 0,
        title: buildUserName(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                controller: controller,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: conversation.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  Map msg = conversation[index];
                  return ChatBubble(
                    message: msg['type'] == "text"
                        ? messages[random.nextInt(10)]
                        : "assets/cm${random.nextInt(10)}.jpeg",
                    username: msg["username"],
                    time: msg["time"],
                    type: msg['type'],
                    replyText: msg["replyText"],
                    isMe: msg['isMe'],
                    isGroup: msg['isGroup'],
                    isReply: msg['isReply'],
                    replyName: name,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                elevation: 10,
                color: Theme.of(context).primaryColor,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 100,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {},
                      ),
                      Flexible(
                        child: TextField(
                          focusNode: focusNode,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Write your message...",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          ChatService().sendFirstMessage(
                            Message(
                              content: "Hey",
                              senderUid: "bIIMBJbUOYO87MiKdZf4FRrAuP83",
                              time: Timestamp.now(),
                              type: "text"
                            ),
                            "wk6Rqjrrb8eQTodJZO0WslU7y7h1",
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildUserName() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/cm${random.nextInt(10)}.jpeg",
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Online",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
