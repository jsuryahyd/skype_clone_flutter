import 'package:flutter/material.dart';
import 'package:skype_clone/models/User.dart';
import 'package:skype_clone/utils/app_variables.dart';
import 'package:skype_clone/widgets/custom_appbar.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen(this.receiver);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String typedMessage = "";
  @override
  void initState() {
    super.initState();
    // messageController = TextEditingController();
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
          title: Text(widget.receiver.userName),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
            IconButton(icon: Icon(Icons.phone), onPressed: () {}),
          ],
          centerTitle: false),
      body: Column(children: <Widget>[chatMessages(), chatControls()]),
    );
  }

  Widget chatMessages() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 6,
        itemBuilder: (context, index) {
          return chatMessageItem();
        },
      ),
    );
  }

  Widget chatMessageItem() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child:
            Container(alignment: Alignment.centerRight, child: senderBubble()));
  }

  Widget senderBubble() {
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
            "Hello jaysurya, how are you?",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }

  Widget selfMsgBubble() {
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
            "Hello jaysurya, how are you?",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }

  Widget chatControls() {
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
            child: TextField(
              onChanged: (val) {
                setState(() {
                  typedMessage = val;
                });
              },
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
                  suffixIcon:
                      GestureDetector(onTap: () {}, child: Icon(Icons.face))),
            ),
          ),
          typedMessage.length == 0
              ? Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.record_voice_over))
              : Container(),
          typedMessage.length == 0
              ? Padding(
                  padding: EdgeInsets.all(8), child: Icon(Icons.camera_alt))
              : Container(),
          typedMessage.length == 0
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
                      onPressed: () {}))
        ],
      ),
    );
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
