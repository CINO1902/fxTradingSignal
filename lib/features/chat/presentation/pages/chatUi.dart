import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fx_trading_signal/features/chat/domain/usecases/chatStates.dart';
import 'package:fx_trading_signal/features/chat/presentation/provider/chatProvider.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/provider/socketProvider.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/utils/appColors.dart';
import '../../../../core/utils/socket.dart';
import '../../../getTraders/presentation/provider/homeProvider.dart';
import '../../domain/usecases/sqlite.dart';
import '../widgets/chabubble.dart';

// Provider for conversation ID
final convoMongoProvider = StateProvider<String>(
  (ref) => '67d2eddda33c0f86f2e9938d',
);

class ChatUI extends ConsumerStatefulWidget {
  final int UnreadMessage;
  final DateTime timeslastmessage;
  const ChatUI({
    Key? key,
    required this.UnreadMessage,
    required this.timeslastmessage,
  }) : super(key: key);

  @override
  ConsumerState<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends ConsumerState<ChatUI> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final SocketService _chatService;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool exists = false;
  @override
  void initState() {
    super.initState();
    _chatService = ref.read(socketServiceProvider);
    getUnreadMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkMessageExist();
      _syncMessages();
    });
  }

  int unreadCount = 0;
  int newMessageCount = 0;
  DateTime newMessageThreshold = DateTime.now();

  void getUnreadMessage() {
    setState(() {
      unreadCount = widget.UnreadMessage;
      newMessageThreshold = widget.timeslastmessage;
    });
  }

  Future<void> checkMessageExist() async {
    exists = await _dbHelper.hasLocalMessages(ref.watch(convoMongoProvider));
    setState(() {}); // Update UI based on the existence flag.
  }

  Future<void> _syncMessages() async {
    debugPrint('Conversation id: ${ref.watch(convoMongoProvider)}');
    debugPrint('Local messages exist: $exists');
    if (!exists) {
      debugPrint(
          'Fetching all messages for conversation: ${ref.watch(convoMongoProvider)}');
      await _dbHelper.getAllMessage(ref.watch(convoMongoProvider), ref);
    } else {
      await _dbHelper.incrementalSync(ref.watch(convoMongoProvider), ref);
    }
  }

  /// Scrolls the ListView to the bottom.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0.0, // In reverse mode, 0.0 represents the bottom.
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void resetNewMessageIndicator() {
    if (mounted) {
      setState(() {
        newMessageThreshold = DateTime.now(); // Set threshold to now
        newMessageCount = 0; // Reset count
      });
    }
  }

  Future<void> _sendMessage() async {
    resetNewMessageIndicator();
    setState(() {
      unreadCount = 0;
    });
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final userData = ref.read(getTraderController).userData;

    // Prepare conversation data
    final conversationData = {
      "_id": null,
      "participants": [
        {
          "_id": userData['userId'],
          "firstname": userData['firstname'],
          "lastname": userData['lastname'],
          "email": userData['email'],
          "image_url": userData['imageUrl'],
        }
      ],
      "createdAt": DateTime.now().toString(),
      "updatedAt": DateTime.now().toString(),
      "__v": 0,
      "lastMessage": content,
    };

    // Insert or update conversation
    final convoId =
        await _dbHelper.insertOrUpdateConversation(conversationData);

    // Insert new message
    final messageId = await _dbHelper.insertMessage({
      'conversationId': ref.read(convoMongoProvider),
      'convoId': convoId,
      'sender': userData['userId'],
      'recipient': 'Admin',
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'isSent': 0,
      'isRead': 0,
    });

    // Prepare unique identifiers using email
    final email = prefs.getString('email');
    final uniqueMessageId = "${messageId}_$email";
    final uniqueConvoId = "${convoId}_$email";

    // Update chat provider state
    ref.read(chatProviderController).updatemessage();

    // Send the message through socket
    _chatService.sendMessage(
      sender: userData['email'],
      messageId: uniqueMessageId,
      conversationId: uniqueConvoId,
      recipient: 'Admin',
      content: content,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final convoId = ref.watch(convoMongoProvider);
    final chatResultState =
        ref.watch(chatProviderController).getChatResult.state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main chat area
          Align(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.kgrayColor50,
                    margin: const EdgeInsets.only(top: 70),
                    child: ref.read(convoMongoProvider) ==
                            '67d2eddda33c0f86f2e9938d'
                        ? ref
                                    .watch(chatProviderController)
                                    .getConVoIDResult
                                    .state ==
                                GetConVoIDResultStates.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.red))
                            : _buildErrorView(
                                'Something went wrong trying to find you message')
                        : !exists
                            ? chatResultState == GetChatResultState.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red))
                                : chatResultState == GetChatResultState.isError
                                    ? _buildErrorView(null)
                                    : chatResultState ==
                                            GetChatResultState.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Send a message to begin conversation with our support',
                                            ),
                                          )
                                        : _buildMessageList(convoId)
                            : _buildMessageList(convoId),
                  ),
                ),
                SafeArea(
                  bottom: true,
                  top: false,
                  child: ChatInput(
                    onSendMessage: _sendMessage,
                    messageController: _messageController,
                  ),
                ),
              ],
            ),
          ),
          // Chat header
          SafeArea(
            child: _buildHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String? errorMessage1) {
    final fallbackMessage =
        ref.read(chatProviderController).getChatResult.response['message'] ??
            'An error occurred';
    final displayMessage = errorMessage1 ?? fallbackMessage;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(displayMessage),
          const Gap(20),
          GestureDetector(
            onTap: () async {
              if (errorMessage1 != null) {
                await ref.read(chatProviderController).getConvoId(
                      ref.watch(getTraderController).userData['token'],
                      ref,
                    );
              }
              await _syncMessages();
            },
            child: Container(
              height: 47,
              width: 130,
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(String convoId) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      color: AppColors.kgrayColor50,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _dbHelper.messageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get all messages for this conversation.
          final messages = snapshot.data!
              .where((msg) => msg['conversationId'] == convoId)
              .toList();

          if (messages.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }

          // Compute new messages based solely on the timestamp.
          final newMessages = messages.where((msg) {
            final DateTime msgTime =
                DateTime.parse(msg['timestamp']).toUtc().toLocal();
            return (msgTime.isAfter(newMessageThreshold) ||
                    msgTime.isAtSameMomentAs(newMessageThreshold)) &&
                msg['sender'] !=
                    ref
                        .read(getTraderController)
                        .userData['userId']; // Exclude messages sent by you
          }).toList();

          // Update our state with the new message count if it has changed.
          if (newMessages.length != newMessageCount) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  newMessageCount = newMessages.length;
                });
              }
            });
          }

          // Find the first message that is considered new.
          int dividerIndex = messages.indexWhere((msg) {
            final DateTime msgTime =
                DateTime.parse(msg['timestamp']).toUtc().toLocal();
            return (msgTime.isAfter(newMessageThreshold) ||
                    msgTime.isAtSameMomentAs(newMessageThreshold)) &&
                msg['sender'] !=
                    ref.read(getTraderController).userData['userId'];
          });
          if (dividerIndex == -1 || newMessageCount == 0) {
            dividerIndex = -1;
          }

          // Adjust total items if we need to insert a divider.
          final int totalItems = messages.length + (dividerIndex != -1 ? 1 : 0);

          return ListView.builder(
            controller: _scrollController,
            reverse: true, // Show new messages at the bottom.
            itemCount: totalItems,
            itemBuilder: (context, index) {
              final int reversedIndex = totalItems - 1 - index;

              // Insert divider at the correct position.
              if (dividerIndex != -1 && reversedIndex == dividerIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.kgrayColor300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        newMessageCount == 1
                            ? "1 New Message"
                            : "$newMessageCount New Messages",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }

              // Adjust message index if the divider is inserted.
              int messageIndex = reversedIndex;
              if (dividerIndex != -1 && reversedIndex > dividerIndex) {
                messageIndex = reversedIndex - 1;
              }

              final msg = messages[messageIndex];
              final bool isSender = msg['sender'] ==
                  ref.read(getTraderController).userData['userId'];

              return VisibilityDetector(
                key: GlobalObjectKey(msg['id'].toString()),
                onVisibilityChanged: (info) {
                  // Mark as read when visible (this does not affect our newMessageCount).
                  if (!isSender && mounted && msg['isRead'] == 0) {
                    DatabaseHelper().upsertMessage(
                        id: msg['id'],
                        isSent: msg['isSent'],
                        timestamp: msg['timestamp'],
                        mongooseId: msg['mongooseId'],
                        isRead: 1);
                    _chatService.updateMessage(messageId: msg['mongooseId']);
                  }
                },
                child: ChatBubble(
                  message: msg['content'],
                  color: isSender
                      ? AppColors.ksuccessColor100
                      : AppColors.kgrayColor300,
                  isSender: isSender,
                  timestamp: msg['timestamp'],
                  isRead: msg['isRead'] == 1,
                  isSent: msg['isSent'] == 1,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/images/chevron-left.png',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Gap(15),
          // Profile picture
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl:
                    'http://res.cloudinary.com/dlsavisdq/image/upload/v1741731996/Fx_signal/tipq4putshlnycqmwly3.jpg',
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      value: progress.progress,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          const Gap(15),
          // Chat title and online status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: const Text(
                  'Admin',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 5,
                    width: 5,
                    child: SvgPicture.asset('assets/svg/dot.svg',
                        color: Colors.green),
                  ),
                  const Gap(5),
                  const Text(
                    'Online',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final VoidCallback onSendMessage;
  final TextEditingController messageController;

  const ChatInput({
    Key? key,
    required this.onSendMessage,
    required this.messageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xffEDEDED)),
              ),
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.04),
                  Image.asset(
                    'assets/images/attachment.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  InkWell(
                    onTap: onSendMessage,
                    child: Image.asset(
                      'assets/images/send.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
