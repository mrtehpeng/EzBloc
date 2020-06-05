/**
 *  Created by @mrtehpeng 2020
 *  https://github.com/mrtehpeng
 *  
 */
import 'package:EzBloc/EzBloc.dart';
import 'package:flutter/material.dart';

/**
 * 
 *    Example
 * 
 */
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() { 
    return _HomePage();
  }

}

class _HomePage extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    ezbloc = EzBloc();
    Function EVENT_CALLBACK = (valueKeys, valueMap) {
      print("Event Callback value=" + valueMap["value"].toString());
      if (valueMap["value"] == 1) {
        return "state1";
      } else return "state2";
    };

    ezbloc.createState("state1");
    ezbloc.createState("state2");
    ezbloc.createEvent("event1", {"value": 1}, EVENT_CALLBACK);
  
  }

  @override
  Widget build(BuildContext context) { 
    return body();
  }

  EzBloc ezbloc;

  Widget body() {

    return Column(children: [

      GestureDetector(child: Text("Button 1"), onTap: () {
        print(" Button 1 clicked ");
        ezbloc.invokeEvent("event1", {"value": 1});
      },),
      
      GestureDetector(child: Text("Button 2"), onTap: () {
        print(" Button 2 clicked ");
        ezbloc.invokeEvent("event1", {"value": 2});
      },),

      result()

    ],);
  }

  Widget result() {

    return ezbloc.EzBlocBuilder(context, (String stateName) {
      print("Bloc Builder callback " + stateName);
      switch (stateName) {
        case "state1":
          return text();
        break;
        case "state2":
          return text2();
        break;
        default:
          return Text("Default");
      }
    });
  }

  Widget text() {
    return Text("Text");
  }
  
  Widget text2() {
    return Text("Text 2");
  }
  
}