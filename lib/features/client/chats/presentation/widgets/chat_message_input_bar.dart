import 'package:flutter/material.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class ChatMessageInputBar extends StatefulWidget {
  const ChatMessageInputBar({
    super.key,
    required this.enabled,
    required this.onSend,
    required this.onAttach,
  });

  final bool enabled;
  final ValueChanged<String> onSend;
  final VoidCallback onAttach;

  @override
  State<ChatMessageInputBar> createState() => _ChatMessageInputBarState();
}

class _ChatMessageInputBarState extends State<ChatMessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: widget.enabled ? widget.onAttach : null,
          icon: const Icon(Icons.attach_file_rounded),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            decoration: InputDecoration(
              hintText: widget.enabled
                  ? 'chat_input_hint'.tr
                  : 'chat_locked_hint'.tr,
            ),
            style: TextStyles.medium16(color: colors.homeHeadline),
            onSubmitted: _submit,
          ),
        ),
        IconButton(
          onPressed: widget.enabled ? () => _submit(_controller.text) : null,
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }

  void _submit(String text) {
    final message = text.trim();
    if (message.isEmpty) {
      return;
    }
    widget.onSend(message);
    _controller.clear();
  }
}
