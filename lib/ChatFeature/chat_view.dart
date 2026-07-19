import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:fcds_announcements/utils/AI%20Model/core_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage {
  final String text;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;
  final String? pdfName;
  final bool isStreaming;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.pdfName,
    this.isStreaming = false,
  });
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late ChatSession _chatSession;

  String? _attachedFileName;
  Uint8List? _attachedFileBytes;
  bool _isLoading = false;

  static const List<String> _generalPrompts = [
    'Explain active recall and spaced repetition study methods.',
    'How can I effectively manage my time as an FCDS student?',
    'What are some tips for studying complex programming topics?',
    'How do I deal with academic stress or exam anxiety?',
    'Can you suggest a general study plan for final exams?',
  ];

  static const List<String> _pdfPrompts = [
    'Summarize this document and highlight the main takeaways.',
    'Extract all dates, deadlines, or schedules mentioned in this PDF.',
    'Create a bulleted list of key action items or requirements.',
    'Generate 5 study/review questions based on this PDF.',
    'Explain the main syllabus topics and grading criteria from this document.',
  ];

  @override
  void initState() {
    super.initState();
    _chatSession = AIModel.model.startChat();
    // Add welcoming message
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your FCDS AI Assistant. How can I help you today? Please choose one of the prompts below or attach a PDF to get started.",
        sender: 'ai',
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickPDF() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      if (result != null) {
        final file = result.files.single.path != null
            ? File(result.files.single.path!)
            : null;
        final bytes = result.files.single.bytes;

        setState(() {
          _attachedFileName = result.files.single.name;
          _attachedFileBytes = bytes ?? (file?.readAsBytesSync());
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick PDF: $e')));
    }
  }

  void _removePDF() {
    setState(() {
      _attachedFileName = null;
      _attachedFileBytes = null;
    });
  }

  Future<void> _sendPrompt(String prompt) async {
    if (_isLoading) return;

    final userMessage = ChatMessage(
      text: prompt,
      sender: 'user',
      timestamp: DateTime.now(),
      pdfName: _attachedFileName,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _scrollToBottom();

    // Store local copies of the attachments
    final fileBytes = _attachedFileBytes;

    // Clear attachments before sending to prevent reuse on next turn
    _removePDF();

    // Insert empty AI message to stream content into
    final aiMessageIndex = _messages.length;
    setState(() {
      _messages.add(
        ChatMessage(
          text: '',
          sender: 'ai',
          timestamp: DateTime.now(),
          isStreaming: true,
        ),
      );
    });
    _scrollToBottom();

    try {
      final content = Content.multi([
        TextPart(prompt),
        if (fileBytes != null) InlineDataPart('application/pdf', fileBytes),
      ]);

      final stream = _chatSession.sendMessageStream(content);
      String accumulatedText = '';

      await for (final chunk in stream) {
        final text = chunk.text;
        if (text != null) {
          accumulatedText += text;
          setState(() {
            _messages[aiMessageIndex] = ChatMessage(
              text: accumulatedText,
              sender: 'ai',
              timestamp: DateTime.now(),
              isStreaming: true,
            );
          });
          _scrollToBottom();
        }
      }

      // Finish streaming
      setState(() {
        _messages[aiMessageIndex] = ChatMessage(
          text: accumulatedText,
          sender: 'ai',
          timestamp: DateTime.now(),
          isStreaming: false,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages[aiMessageIndex] = ChatMessage(
          text:
              'Oops! I encountered an error while processing your request:\n$e',
          sender: 'ai',
          timestamp: DateTime.now(),
          isStreaming: false,
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _removePDF();
      _chatSession = AIModel.model.startChat();
      _messages.add(
        ChatMessage(
          text:
              "Chat cleared. What else can I help you with? You can select a prompt or attach a PDF.",
          sender: 'ai',
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final prompts = _attachedFileName != null ? _pdfPrompts : _generalPrompts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FCDS AI Assistant',
          style: MyTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear Chat',
            onPressed: _messages.length > 1 && !_isLoading ? _clearChat : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat history area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg.sender == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isUser ? 16 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (msg.pdfName != null) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    size: 14,
                                    color: isUser
                                        ? Colors.white
                                        : colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      msg.pdfName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isUser
                                            ? Colors.white70
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          MarkdownBody(
                            data: msg.text.isEmpty && msg.isStreaming
                                ? 'Thinking...'
                                : msg.text,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // PDF Attachment Preview (if selected)
            if (_attachedFileName != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: colorScheme.error,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _attachedFileName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _isLoading ? null : _removePDF,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

            // Predefined Prompts Area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: colorScheme.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Text(
                      _attachedFileName != null
                          ? 'PDF Prompts'
                          : 'Suggested Prompts',
                      style: MyTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: prompts.length,
                      itemBuilder: (context, index) {
                        final prompt = prompts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ActionChip(
                            label: Text(
                              prompt,
                              style: MyTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () => _sendPrompt(prompt),
                            backgroundColor: colorScheme.surface,
                            side: BorderSide(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Fixed input area displaying disabled text box and attachment option
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: _attachedFileName != null
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    tooltip: 'Attach PDF',
                    onPressed: _isLoading ? null : _pickPDF,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Select a prompt above to send',
                        style: MyTextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
