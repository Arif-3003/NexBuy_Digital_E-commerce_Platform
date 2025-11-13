import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utility/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_Msg> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _sendQuery(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.insert(0, _Msg(text: text, fromUser: true));
      _loading = true;
    });
    _controller.clear();

    try {
      final url = Uri.parse('$MAIN_URL/bot/query');
      final response = await http.post(
        url,
        body: jsonEncode({'q': text}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.insert(0, _Msg(text: data['answer'] ?? 'No response', fromUser: false));
        });
      } else {
        _messages.insert(0, _Msg(text: 'Error: ${response.statusCode}', fromUser: false));
      }
    } catch (e) {
      _messages.insert(0, _Msg(text: 'Network error: $e', fromUser: false));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with NexBuyBot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.fromUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.fromUser
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.fromUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask me about a product...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _sendQuery,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendQuery(_controller.text),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool fromUser;
  _Msg({required this.text, required this.fromUser});
}
