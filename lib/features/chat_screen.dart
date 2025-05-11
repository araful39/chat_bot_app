import 'package:chat_bot_app/features/gemini_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.insert(0, {"text": userText, "isMe": true});
      _controller.clear();
    });

    final botReply = await _geminiService.getGeminiResponse(userText);

    setState(() {
      _messages.insert(0, {"text": botReply, "isMe": false});
    });
  }

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
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Row(
                  mainAxisAlignment:
                      message["isMe"]
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.end,
                  children: [
                    if (!message["isMe"])
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/bot.png'),
                        ),
                      ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              message["isMe"] ? Colors.teal : Colors.grey[300],
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
                            color:
                                message["isMe"] ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
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
                    controller: _controller,
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
                    onPressed: _sendMessage,
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
