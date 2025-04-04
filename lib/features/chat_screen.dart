import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/bot.png')),
            SizedBox(width: 10),
            Text("Gemini bot"),
          ],
        ),
        backgroundColor: Colors.teal,
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Row(
                  mainAxisAlignment:
                      message["isMe"]
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    if (!message["isMe"])
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/bot.png'),
                      ),
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: message["isMe"] ? Colors.teal : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft:
                              message["isMe"]
                                  ? Radius.circular(15)
                                  : Radius.zero,
                          bottomRight:
                              message["isMe"]
                                  ? Radius.zero
                                  : Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        message["text"],
                        style: TextStyle(
                          color: message["isMe"] ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions, color: Colors.teal),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.teal),
                  onPressed: () {},
                ),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> messages = [
  {"text": "Hey! How's it going?", "isMe": false},
  {"text": "I'm good, just working on a project.", "isMe": true},
  {"text": "That sounds great! Need any help?", "isMe": false},
];
