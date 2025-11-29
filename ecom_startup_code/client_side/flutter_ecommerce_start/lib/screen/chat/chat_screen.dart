// lib/screen/chat/chat_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

  final List<String> prePrompts = [
    "Here,You can know about ourselves!!!",
    "Here,You can find a product, it's details and it's availability by it's name!!!",
    "Here,You can search a product's details and availability by it's image !!!",
    "Track your order by product name"
  ];

  // -------------------------------
  // SEND QUERY (text) -> includes userId if logged in
  // -------------------------------
  Future<void> _sendQuery(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, _Msg(text: text, fromUser: true));
      _loading = true;
    });
    _controller.clear();

    try {
      // get logged-in user id, if available
      String? userId;
      try {
        // safe guard: context.userProvider exists in your app because you used Provider
        final user = context.userProvider.getLoginUsr();
        userId = user?.sId;
      } catch (_) {
        userId = null;
      }

      final url = Uri.parse('$MAIN_URL/bot/query');
      final body = jsonEncode({
        'q': text,
        if (userId != null) 'userId': userId, // include userId when available
      });

      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.insert(
              0, _Msg(text: data['answer'] ?? 'No response', fromUser: false));
        });
      } else {
        _messages.insert(
            0, _Msg(text: 'Error: ${response.statusCode}', fromUser: false));
      }
    } catch (e) {
      _messages.insert(0, _Msg(text: 'Network error: $e', fromUser: false));
    }

    setState(() => _loading = false);
  }

  // -------------------------------
  // IMAGE SEARCH (unchanged logic)
  // -------------------------------
  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _messages.insert(0, _Msg(text: "Image selected.", fromUser: true));
      _loading = true;
    });

    var request =
    http.MultipartRequest('POST', Uri.parse('$MAIN_URL/bot/image-search'));

    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      final r = await request.send();
      final resBody = await r.stream.bytesToString();
      final data = jsonDecode(resBody);

      setState(() {
        _messages.insert(0, _Msg(text: data['answer'] ?? 'No response', fromUser: false));
      });
    } catch (e) {
      _messages.insert(0, _Msg(text: "Image upload failed: $e", fromUser: false));
    }

    setState(() => _loading = false);
  }

  Widget _buildPrePrompts() {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: prePrompts.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ActionChip(
              label: Text(
                text,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              backgroundColor: Colors.blue, // blue prompts as you requested
              onPressed: () {
                // if user taps the prompt we send it immediately for convenience
                _controller.text = text;
                _sendQuery(text);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Chat with NexBuyBot')),
      body: Column(
        children: [
          _buildPrePrompts(),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.fromUser;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 14,
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
                  IconButton(
                    icon: const Icon(Icons.image, size: 30),
                    onPressed: _sendImage,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Ask me about a product or order...",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _sendQuery,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, size: 30),
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
