import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  String imageUrl;
  String senderId;
  String receiverThreadId;
  String receiverThreadType;
  Timestamp timestamp;
  Message(
      {this.text,
      this.imageUrl,
      this.senderId,
      this.receiverThreadId,
      this.receiverThreadType,
      this.timestamp}){
        this.timestamp = this.timestamp ??  Timestamp.now();
      }

  Message.fromMap(Map messageDetails) {
    this.text = messageDetails['text'];
    this.imageUrl = messageDetails['imageUrl'];
    this.senderId = messageDetails['senderId'];
    this.receiverThreadId = messageDetails['receiverThreadId'];
    this.receiverThreadType = messageDetails['receiverThreadType'];
    this.timestamp = messageDetails['timestamp'] == null
        ? Timestamp.now()
        : messageDetails['timestamp'];
  }

  toMap() {
    return {
      "text": this.text,
      "imageUrl": this.imageUrl,
      "senderId": this.senderId,
      "receiverThreadId": this.receiverThreadId,
      "receiverThreadType": this.receiverThreadType,
      "timestamp":this.timestamp
    };
  }
}
