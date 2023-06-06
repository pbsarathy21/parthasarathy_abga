import 'package:flutter/material.dart';

import '../models/message_view.dart';

class MessageTile extends StatelessWidget {
  final MessageDetail messageDetail;
  const MessageTile({super.key, required this.messageDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      width: double.infinity,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xffD3D3D3),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(messageDetail.sender, style: const TextStyle(fontSize: 18)),
                  Text(messageDetail.date, style: const TextStyle(fontSize: 18))
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("AED ${messageDetail.amount}", style: const TextStyle(fontSize: 15)),
                  const Text('Click to show', style: TextStyle(fontSize: 13))
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                child: Text(messageDetail.body),
              )
            ],
          ),
        ),
      ),
    );
  }

}