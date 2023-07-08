import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/main.dart';
import 'Colors.dart';

class NegativeButton extends StatelessWidget {
  const NegativeButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: Color(0xFF036CB2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: onPressed,
      icon: FaIcon(
        FontAwesomeIcons.times,
        size: 15,
      ),
      label: Text(text,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.headlineMedium
          // const TextStyle(
          //     fontWeight: FontWeight.normal, fontSize: Theme.of(context).textTheme.bodyText1,
          //     color: Colors.white),
          ),
    );
  }
}
// ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.cancel_outlined,),
// label: Text('Cancel',),
// style:ElevatedButton.styleFrom(primary: Colors.deepOrange,shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20),
// ))
// ),
