import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/models/User.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/thread.dart';
import 'package:skype_clone/utils/app_variables.dart';
import 'package:skype_clone/widgets/custom_appbar.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  final Thread thread;
  ChatScreen(this.thread, {this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String typedMessage = "";

  bool showEmojiPicker = false;

  FocusNode messageInputFocus = FocusNode();

  FirebaseRepo _firebaseRepo = FirebaseRepo();
  FirebaseUser currentUser;
  Thread currentThread;

  ScrollController msgsListScroll = ScrollController();
  @override
  void initState() {
    currentThread = widget.thread;
    super.initState();
    // messageController = TextEditingController();
    _firebaseRepo.getLoggedInUser().then((value) {
      setState(() {
        currentUser = value;
      });

      if (widget.thread == null) {
        //create a thread with receiver and currentUser
        Thread newThread = new Thread(
            type: "one-to-one",
            userUids: [value.uid, widget.receiver.uid],
            createdAt: Timestamp.now());
        _firebaseRepo.createThread(newThread).then((threadDoc) {
          print(threadDoc);
          newThread.uid = threadDoc.documentID;
          currentThread = newThread;
          setState(() {});
          //todo: update threads and users without threads in past screen : can be done via global state
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppVariables.blackColor,
      appBar: CustomAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(currentThread == null
              ? (widget.receiver != null ? widget.receiver.name : "")
              : currentThread.userNames().join(",")), //widget.receiver.userName
          actions: <Widget>[
            IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
            IconButton(icon: Icon(Icons.phone), onPressed: () {}),
          ],
          centerTitle: false),
      body: currentUser == null || currentThread == null
          ? Container()
          : Column(children: <Widget>[
              chatMessages(),
              chatControls(),
              Container(child: showEmojiPicker ? emojiContainer() : null)
            ]),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      onEmojiSelected: (emoji, category) {
        messageController.text = messageController.text + emoji.emoji;
        setState(() {}); //trigger re-render to show bluebutton
      },
      bgColor: AppVariables.separatorColor,
      indicatorColor: AppVariables.blueColor,
      rows: 3,
      columns: 7,
      numRecommended: 50,
    );
  }

  Widget chatMessages() {
    return Expanded(
      child: StreamBuilder(
          stream: _firebaseRepo.fetchThreadMessages(currentThread.uid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: EdgeInsets.all(10),
              reverse: true,
              controller: msgsListScroll,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                Message msg =
                    Message.fromMap(snapshot.data.documents[index].data);
                return chatMessageItem(msg);
              },
            );
          }),
    );
  }

  Widget chatMessageItem(Message msg) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Container(
            alignment: msg.senderId == currentUser.uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: msg.senderId == currentUser.uid
                ? selfMsgBubble(msg.text)
                : senderBubble(msg.text)));
  }

  Widget senderBubble(text) {
    Radius radius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppVariables.senderColor,
          borderRadius: BorderRadius.only(
              bottomLeft: radius, bottomRight: radius, topRight: radius)),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }

  Widget selfMsgBubble(text) {
    Radius radius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppVariables.senderColor,
          borderRadius: BorderRadius.only(
              bottomLeft: radius, topLeft: radius, topRight: radius)),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }

  Widget chatControls() {
    if (currentThread != null) {
      print(currentThread);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              openMediaModal();
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.add),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: AppVariables.fabGradient),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(children: [
              TextField(
                onChanged: (val) {
                  setState(() {
                    //empty, but trigger s ternarychecks for send button.
                  });
                  // setState(() {
                  //   typedMessage = val;
                  // });
                },
                focusNode: messageInputFocus,
                style: TextStyle(color: Colors.white),
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: AppVariables.greyColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(50))),
                  filled: true,
                  fillColor: AppVariables.separatorColor,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
              ),
              Align(
                  child: IconButton(
                      onPressed: () {
                        if (!showEmojiPicker) {
                          showEmojiContainer();
                          hideKeyboard();
                        } else {
                          showKeyboard();
                          hideEmojiContainer();
                        }
                      },
                      icon: Icon(Icons.face)),
                  alignment: Alignment.centerRight)
            ]),
          ),
          messageController.text.length == 0
              ? Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.record_voice_over))
              : Container(),
          messageController.text.length == 0
              ? Padding(
                  padding: EdgeInsets.all(8), child: Icon(Icons.camera_alt))
              : Container(),
          messageController.text.length == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: AppVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 20,
                      ),
                      onPressed: () {
                        sendMessage();
                      }))
        ],
      ),
    );
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showKeyboard() {
    setState(() {
      messageInputFocus.requestFocus();
    });
  }

  hideKeyboard() {
    setState(() {
      messageInputFocus.unfocus();
    });
  }

  sendMessage() {
    String message = messageController.text;
    _firebaseRepo.addMessageToDb(
      Message(
          text: message,
          senderId: currentUser.uid,
          receiverThreadId: currentThread.uid,
          receiverThreadType: "one-to-one"),
    );
    messageController.clear();
    showEmojiPicker = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      msgsListScroll.animateTo(msgsListScroll.position.minScrollExtent,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    });
    setState(() {}); //ui update
  }

  openMediaModal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppVariables.blackColor,
        elevation: 0,
        builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        icon: Icon(Icons.close)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and Tools",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView(children: [
                ModalTile(
                  title: "Media",
                  subTitle: "Share Photos and Video",
                  icon: Icons.image,
                ),
                ModalTile(
                    title: "File", subTitle: "Share files", icon: Icons.tab),
                ModalTile(
                    title: "Contact",
                    subTitle: "Share contacts",
                    icon: Icons.contacts),
                ModalTile(
                    title: "Location",
                    subTitle: "Share a location",
                    icon: Icons.add_location),
                ModalTile(
                    title: "Schedule Call",
                    subTitle: "Arrange a skype call and get reminders",
                    icon: Icons.schedule),
                ModalTile(
                    title: "Create Poll",
                    subTitle: "Share polls",
                    icon: Icons.poll)
              ]))
            ],
          );
        });
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  ModalTile({
    @required this.title,
    @required this.subTitle,
    @required this.icon,
  });

  build(BuildContext context) {
    return CustomTile(
        isMini: false,
        leading: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: AppVariables.receiverColor),
            child: Icon(
              icon,
              size: 38,
              color: AppVariables.greyColor,
            )),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subTitle: Text(subTitle,
            style: TextStyle(color: AppVariables.greyColor, fontSize: 14)));
  }
}
