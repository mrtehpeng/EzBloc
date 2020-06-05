# EzBloc

Flutter Bloc Wrapper.

You do not need to create multiple classes anymore! Just grab any events or states with a `String`.


---
 
### EzBloc.dart

**Methods** 

---
 
```
  createEvent(@required String eventName , @required Map valueMap, @required Function callback)
```

Creates a new `EzBlocEvent` with identifier `eventName` with initial values `valueMap` and a `callback` function
to determine the state based on values in `valueMap`.
 
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
    Function EVENT_CALLBACK = (valueKeys, valueMap) {
      print("Event Callback value=" + valueMap["value"].toString());
      if (valueMap["value"] == 1) {
        return "state1";
      } else return "state2";
    };

    ezbloc.createState("RED_TEXT");
    ezbloc.createState("BLUE_TEXT");
    ezbloc.createEvent("BUTTON_CLICKED", {"value": 1}, EVENT_CALLBACK);
  
  }
  
@override
Widget build(BuildContext context) {

  return Column(children: [

          GestureDetector(child: Text("Click for red text"), onTap: () {
 
            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 1})
         }),
 
          GestureDetector(child: Text("Click for blue text"), onTap: () {
 
            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 2})
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
