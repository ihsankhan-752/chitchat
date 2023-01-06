import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class MessageTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? onPressed;
  final Function()? picSelectionTapped;
  const MessageTextInput({Key? key, this.controller, this.onPressed, this.picSelectionTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.PRIMARY_BLACK,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: AppColors.PRIMARY_WHITE,
        ),
        decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            isDense: true,
            prefixIcon: IconButton(
              onPressed: picSelectionTapped,
              icon: Icon(Icons.photo, color: AppColors.PRIMARY_WHITE),
            ),
            hintText: "Message....",
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.send,
                color: AppColors.PRIMARY_WHITE,
              ),
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            )),
      ),
    );
  }
}

// DocumentSnapshot userSnap = await _firestore.collection("users").doc(myId).get();
// try {
//   DocumentSnapshot snap = await _firestore.collection("chat").doc(docId).get();
//   if (snap.exists) {
//     await _firestore.collection("chat").doc(docId).update({
//       "lastMsg": msgController.text,
//       "createdAt": DateTime.now(),
//     });
//   } else {
//     await _firestore.collection("chat").doc(docId).set({
//       "lastMsg": msgController.text,
//       "userIds": [myId, widget.userId],
//       "createdAt": DateTime.now(),
//     });
//   }
//   await _firestore.collection("chat").doc(docId).collection("messages").add({
//     "msg": msgController.text,
//     "senderId": myId,
//     "userImage": userSnap['image'],
//     "username": userSnap['username'],
//     "createdAt": DateTime.now(),
//   });
//   msgController.clear();
//   setState(() {});
// } catch (e) {
//   showMessage(context, e.toString());
// }
