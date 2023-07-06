import 'package:flutter/material.dart';


class ContainerValue extends StatelessWidget {
  ContainerValue({Key? key, required this.text, required this.value ,}) : super(key: key);
var text;
final  String value;

  @override
  Widget build(BuildContext context) {

      return Container(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall
                ),
              ),
              //VerticalDivider(width: 1,),
              Expanded(
                child: Text(
                  value,
                    style: Theme.of(context).textTheme.bodySmall
                ),
              ),
            ],
          ),
        ),
      );

  }
}
