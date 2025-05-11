import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_messages);
    await prefs.setString('chat_messages', encoded);
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_messages');
    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  Future<void> _clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
    setState(() {
      _messages.clear();
    });
  }

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.insert(0, {"text": userText, "isMe": true});
      _controller.clear();
    });
    await _saveMessages();

    final history = _messages.reversed.toList();

    final botReply = await _geminiService.getGeminiResponse(history);

    setState(() {
      _messages.insert(0, {"text": botReply, "isMe": false});
    });
    await _saveMessages();
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return Row(
      mainAxisAlignment:
          message["isMe"] ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message["isMe"])
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(backgroundImage: AssetImage('assets/bot.png')),
          ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: message["isMe"] ? Colors.teal : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: message["isMe"] ? Radius.circular(15) : Radius.zero,
                bottomRight:
                    message["isMe"] ? Radius.zero : Radius.circular(15),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/bot.png')),
            SizedBox(width: 10),
            Text("Gemini Bot"),
          ],
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _clearMessages,
            tooltip: "Clear chat",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, index) => _buildMessage(_messages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
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
                SizedBox(width: 10),
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
