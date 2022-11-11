import "package:flutter/material.dart";

class BrewListTile extends StatefulWidget {
  final String user;
  final String amount;
  final dynamic brewColor;
  const BrewListTile({
    Key? key,
    required this.user,
    required this.amount,
    required this.brewColor,
  }) : super(key: key);

  @override
  State<BrewListTile> createState() => _BrewListTileState();
}

class _BrewListTileState extends State<BrewListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 20,
        ),
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: widget.brewColor,
              backgroundImage:
                  const AssetImage("lib/assets/img/coffee_icon.png"),
            ),
          ],
        ),
        title: Text(widget.user),
        subtitle: Text("Take ${widget.amount.toString()} Sugar(s)"),
      ),
    );
  }
}
