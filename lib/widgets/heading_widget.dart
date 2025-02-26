import 'package:flutter/material.dart';

import '../utils/app-constant.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubTItle;
  final VoidCallback onTap;
  final String buttonText;

  const HeadingWidget(
      {super.key,
      required this.headingTitle,
      required this.headingSubTItle,
      required this.onTap,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingTitle,
                style:
                    TextStyle(fontSize: 18, color: AppConstant.appTextColor),
              ),
              Text(
                headingSubTItle,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),

              ),
            ],
          ),
          SizedBox(
            width: 100,
            child: OutlinedButton(
              onPressed: onTap, // ✅ Now correctly calls the onTap function
              child: Text(
                buttonText,
                style: TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
