import 'package:flutter/material.dart';

class FriendActionButton extends StatelessWidget {
  final String iconName;
  final String title;
  final String subTitle;
  final bool isFriend;
  final VoidCallback clickAction;

  const FriendActionButton({
    Key? key,
    required this.iconName,
    required this.title,
    required this.subTitle,
    required this.isFriend,
    required this.clickAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                isFriend ? Icons.person_remove : Icons.person_add,
                color: isFriend ? Colors.redAccent : Colors.green,
                size: 36,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
