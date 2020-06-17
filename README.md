# Flutter EzBloc

![Flutter](https://camo.githubusercontent.com/9dedd2d58eefa0b363a70397864018e8045d60e4/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4d616465253230576974682d466c75747465722d626c75653f7374796c653d666c61742d737175617265 "Made with Flutter") ![License](https://camo.githubusercontent.com/57eaa4dd1013971849ec1d46acb5273827b25861/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f7468656d696e6473746f726d2f4e65787442757353673f7374796c653d666c61742d737175617265 
"License") [![HitCount](http://hits.dwyl.com/mrtehpeng/tehpeng/EzBloc.svg)](http://hits.dwyl.com/mrtehpeng/tehpeng/EzBloc) <a href="https://www.buymeacoffee.com/icedmilo" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" width="108" height="25" ></a>

## Flutter Bloc Wrapper 

You do not need to create multiple classes anymore! Just grab any events or states with a `String`.


---

### Packages used

```
flutter_bloc: ^4.0.0
bloc: ^4.0.0
```

---

### Step 1. Create Events and States with one command 

```
// Create a handler to determine resulting state from the invoked eventName
Function EVENT_CALLBACK = (String eventName, valueKeys, valueMap) { 
      if (eventName == "RED_BUTTON_CLICKED") {
        // It will print {"value": 3"}  ( See Step 2. Invoke Event )
        print(valueMap);
        return "RED_TEXT";
      } else { 
        // It will print {"value": 2"}
        print(valueMap);
        return "BLUE_TEXT";
        
      }
      
      // default fallback event
      return "BLUE_TEXT";
    };
   
// Create states
ezbloc.createState("RED_TEXT");
ezbloc.createState("BLUE_TEXT");

// Create Events with their initial values and set the handler (EVENT_CALLBACK) 
ezbloc.createEvent("RED_BUTTON_CLICKED", {"value": 1}, EVENT_CALLBACK);
ezbloc.createEvent("BLUE_BUTTON_CLICKED", {"value": 2}, EVENT_CALLBACK);
```

### Step 2. Invoke Event
```
 // Put inside a ontap listener or something
 // Update event value to {"value": 3}
 // EVENT_CALLBACK will be called (See Step 1. )
 ezbloc.invokeEvent("RED_BUTTON_CLICKED", {"value": 3});
```

### Step 3. Return Widgets based on current state
```
  Widget resultingWidget = ezbloc.EzBlocBuilder(context, (String stateName) {
        switch(stateName) {
          case "RED_TEXT":
            return Text("Red Text", style: TextStyle(color: Colors.red));
          break;
          case "BLUE_TEXT":
             return Text("Blue Text", style: TextStyle(color: Colors.blue));
          break;
          
          
          // Default Widget to be returned on first load.
          // (Default state)
          default:
            return Text("Default Text", style: TextStyle(color: Colors.black));
          break;
          }
      });
```

---
 
### EzBloc.dart

**Methods** 
 
```
  createEvent(@required String eventName , @required Map valueMap, @required Function callback)
```

Creates a new `EzBlocEvent` with identifier `eventName` with initial values `valueMap` and a `callback` function
to determine the state based on values in `valueMap`.

`callback` **must** have 3 arguments: `String eventName`, `List<String> valueKeys`, `Map valueMap`
 
---
 
```
  createState(@required String stateName)
```

Creates a new `EzBlocState` with identifier `stateName`

---
 
```
  invokeEvent(@required String eventName, @required Map newEventValues)
```

Calls `Bloc` event with identifier `eventName` with new values in `newEventValues`

---
 
```
  showLog(@required bool show)
```

Show / Hide logs printed in `EzBloc` class. Default: true

---
 

```
  Widget EzBlocBuilder(BuildContext context, Function stateHandler)
```

Callback `stateHandler` determines which `Widget` to return based on its argument `stateName`

StateHandler: `Widget stateHandler(stateName)`

---
 
### Example

```

@override
  void initState() {
    super.initState();

    ezbloc = EzBloc();
    
    // Example 1 : Using valueMap to determine resulting state
    Function EVENT_CALLBACK = (String eventName, valueKeys, valueMap) {
      print("Event Callback value=" + valueMap["value"].toString());
      if (valueMap["value"] == 1) {
        return "state1";
      } else return "state2";
    };

    ezbloc.createState("RED_TEXT");
    ezbloc.createState("BLUE_TEXT");
    ezbloc.createEvent("BUTTON_CLICKED", {"value": 1}, EVENT_CALLBACK);
    
    // Example 2 : Using eventName to determine resulting state
    Function BUTTON_EVENT_CALLBACK = (String eventName, valueKeys, valueMap) { 
      if (eventName == "RED_BUTTON_CLICKED") { 
        return "RED_TEXT"; 
      } else return "BLUE_TEXT"; 
    }; 
 
    // values are not needed in this example
    ezbloc.createEvent("RED_BUTTON_CLICKED", {}, BUTTON_EVENT_CALLBACK);
    ezbloc.createEvent("BLUE_BUTTON_CLICKED", {}, BUTTON_EVENT_CALLBACK);
  
  }
  
@override
Widget build(BuildContext context) {

  Widget colouredText = ezbloc.EzBlocBuilder(context, (String stateName) {
        switch(stateName) {
          case "RED_TEXT":
            return Text("Red Text", style: TextStyle(color: Colors.red));
          break;
          case "BLUE_TEXT":
             return Text("Blue Text", style: TextStyle(color: Colors.blue));
          break;
          default:
            return Text("Default Text", style: TextStyle(color: Colors.black));
          break;
          }
      });

  return Column(children: [

          GestureDetector(child: Text("Click for red text"), onTap: () {
   
            // Using example 1 
            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 1});
            
            // Using example 2
            ezbloc.invokeEvent("RED_BUTTON_CLICKED", {});
         }),
 
          GestureDetector(child: Text("Click for blue text"), onTap: () {
 
            // Using example 1
            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 2});
            
            // Using example 2
            ezbloc.invokeEvent("RED_BUTTON_CLICKED", {});
          }),
 
          colouredText,
 
      ]);
}
```



---
 
### Credits

@mrtehpeng

> Tehpeng

> 6 June 2020
