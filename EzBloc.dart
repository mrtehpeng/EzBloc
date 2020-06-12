/**
 *  Created by @mrtehpeng 2020
 *  https://github.com/mrtehpeng
 *  
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EzBlocBaseState {}
abstract class EzBlocBaseEvent {}

class EzBlocEmptyState extends EzBlocBaseState {
  String stateName = "EMPTY";
}

class EzBlocState extends EzBlocBaseState {
  String stateName;
  Map map;
  EzBlocState(this.stateName, this.map);
}

class EzBlocEvent extends EzBlocBaseEvent {
  String eventName;
  Map map;
  EzBlocEvent(this.eventName, this.map);
}

/**
 * 
 * ## Bloc
 * 
 * ```
 *  EzBloc()
 * ```
 * **Initial State**: `EMPTY`
 * 
 * ## Methods
 * 
 * ### **Create Event**
 * 
 * ```
 *  createEvent(@required String eventName , @required Map valueMap, @required Function callback)
 * ```
 * 
 * Creates a new `EzBlocEvent` with identifier `eventName` with initial values `valueMap` and a `callback` function
 * to determine the state based on values in `valueMap`.
 * 
 * 
 * ### **Create State**
 * 
 * ```
 *  createState(@required String stateName)
 * ```
 * 
 * Creates a new `EzBlocState` with identifier `stateName`
 *  
 * ### Call Event 
 * 
 * ```
 *  invokeEvent(@required String eventName, @required Map newEventValues)
 * ```
 * 
 *  Calls `Bloc` event with identifier `eventName` with new values in `newEventValues`
 * 
 * ### **Show/Hide logs**
 * 
 * ```
 *  showLog(@required bool show)
 * ```
 *  
 *  Show / Hide logs printed in `EzBloc` class. Default: true
 * 
 * ### **Build Widget based on State**
 * 
 * ```
 *  Widget EzBlocBuilder(BuildContext context, Function stateHandler)
 * ```
 * 
 * `Widget stateHandler(stateName)`
 * 
 * Callback `stateHandler` determines which `Widget` to return based on its argument `stateName`
 * 
 * ## Example Usage ##
 * ```
 *  // StatefulWidget
 *  EzBloc ezbloc;
 * 
 *  @override
 *  void initState() {
 *    super.initState();
 *    ezbloc = EzBloc();
 * 
 *    // Example 1 - Using valueMap to determine resulting state
 *    Function EVENT_CALLBACK = (String eventName, valueKeys, valueMap) {
 *      print("Event Callback value=" + valueMap["value"].toString());
 *      if (valueMap["value"] == 1) { 
 *        return "RED_TEXT"; 
 *      } else return "BLUE_TEXT"; 
 *    }; 
 * 
 *    ezbloc.createState("RED_TEXT"); 
 *    ezbloc.createState("BLUE_TEXT"); 
 *    ezbloc.createEvent("BUTTON_CLICKED", {"value": 1}, EVENT_CALLBACK);
 * 
 *    // Example 2 : Using eventName to determine resulting state
 *    Function EVENT_CALLBACK = (String eventName, valueKeys, valueMap) { 
 *      if (eventName == "RED_BUTTON_CLICKED") { 
 *        return "RED_TEXT"; 
 *      } else return "BLUE_TEXT"; 
 *    }; 
 * 
 *    // values are not needed in this example
 *    ezbloc.createEvent("RED_BUTTON_CLICKED", {}, BUTTON_EVENT_CALLBACK);
 *    ezbloc.createEvent("BLUE_BUTTON_CLICKED", {}, BUTTON_EVENT_CALLBACK);
 * 
 *  }
 * 
 *  @override
 *  Widget build(BuildContext context) {
 *      
 *      Widget colouredText = ezbloc.EzBlocBuilder(context, (String stateName) {
 *        switch(stateName) {
 *          case "RED_TEXT":
 *            return Text("Red Text", style: TextStyle(color: Colors.red));
 *          break;
 *          case "BLUE_TEXT":
 *             return Text("Blue Text", style: TextStyle(color: Colors.blue));
 *          break;
 *          default:
 *            return Text("Default Text", style: TextStyle(color: Colors.black));
 *          break;
 *      
 *  
 *          }
 *      });
 * 
 *      return Column(children: [
 * 
 *          GestureDetector(child: Text("Click for red text"), onTap: () {
 * 
 *            // example 1
 *            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 1});
 * 
 *            // example 2
 *            ezbloc.invokeEvent("RED_BUTTON_CLICKED", {});
 *          }),
 * 
 *          GestureDetector(child: Text("Click for blue text"), onTap: () {
 * 
 *            // example 1
 *            ezbloc.invokeEvent("BUTTON_CLICKED", {"value": 2});
 * 
 *            // example 2
 *            ezbloc.invokeEvent("BLUE_BUTTON_CLICKED", {});
 *          }),
 * 
 *          colouredText,
 * 
 *      ]);
 *  }
 * ```
 */
class EzBloc extends Bloc<EzBlocEvent, EzBlocBaseState> {

  Map<String, dynamic> _events = Map();
  Map<String, dynamic> _states = Map();
  
  /**
   * ## Arguments
   * 
   *      @param: eventName (String) - 
   * 
   * Identifier of the new state
   * 
   *      @param: valueMap (Map<String, dynamic>) - 
   * 
   * Values of the Event with String identifier
   *                
   * Example: `{"value1" => 1, "value2" => "STRING_VALUE"}`
   * 
   *      @param: callback (Function) - 
   * 
   * This callback function will be executed in `mapEventToState` to get which state to return based on the eventName parameter.
   * 
   * It **must** contain three arguments `(String eventName, List<String> argNames, Map<String, dynamic> argMap)`. (See below)
   *         
   * This function **must** return a `String` - Name of the state you have identified previously
   *       
   *     @returns void
   * 
   * ### Function `callback`
   * 
   *      @param: currentEvent (String) -
   * 
   * The last invoked event. You can use this to determine the resulting state.
   *
   *      @param: argKeys (List<String>) - 
   * 
   * List of keys in valueMap
   * 
   *      @param: argMap (Map<String, dynamic>) - 
   * 
   * valueMap : Values of the event with String identifier
   *        
   *      @returns: stateName (String) - 
   * 
   * Return the identifier of the target state
   *    
   * 
   * ## Description 
   * 
   *  Initialise a State tagged with stateName
   * 
   * 
   * ## Example
   * ```
   *  ezBloc.createEvent("BUTTON_CLICKED", {"selected": false, "num_click": 0}, (currentEvent, argKeys, argMap) {
   *    if (argMap["selected"]) {
   *      return "BUTTON_SELECTED_STATE"; 
   *    } else {
   *      return "BUTTON_UNSELECTED_STATE";
   *    }
   *  })
   * ```
   */
  createEvent(@required String eventName , @required Map valueMap, @required Function callback) {
    
    if (!_events.containsKey(eventName)) {
      _events[eventName] = {
        "event": EzBlocEvent(eventName, valueMap),
        "callback": callback
      }; 
    } else {
      _log("Event " + eventName + " is already defined!");
    }
  }

  /**
   *  ## Arguments 
   * 
   *      @param: stateName (String) - 
   * 
   *    Identifier of the new state
   * 
   *      @returns: void
   * 
   *  ## Description
   * 
   *    Initialise a State tagged with stateName
   *
   */
  createState(@required String stateName) { 
    if (!_states.containsKey(stateName)) {
      _states[stateName] = EzBlocState(stateName, {}); 
    } else {
      _log("State " + stateName + " is already defined!");
    }
  }

  /**
   *  ## Arguments
   * 
   *      @param: eventName (String) - 
   * 
   *  Name of the event you have defined
   * 
   *      @param: newEventValues (Map<String, dynamic>) -
   * 
   *  New Event Values that may be used to determine the state
   * 
   *  ## Description
   * 
   *  Adds BlocEvent into Bloc to trigger `mapEventToState`
   *
   *      @returns: void
   * 
   *  ## Example
   *  ```
   *    // Global variable
   *    num num_clicked = 1;
   *    bool selected = false;
   *    EzBloc ezbloc = EzBloc();
   *     ...
   *    // Inside Button onclick
   *    ezbloc.invokeEvent("BUTTON_CLICKED", {"selected": selected, "num_click": num_clicked});
   *     ...
   *  ```
   */
  invokeEvent(@required String eventName, @required Map newEventValues) {
    EzBlocEvent newEvent = EzBlocEvent(eventName, newEventValues); 
    _events[eventName]["event"] = newEvent;
    this.add(newEvent);  
  }

  /**
   * 
   *  ## Arguments
   * 
   *      @param show (bool)
   * 
   *  Show or Hide logs printed in this class
   * 
   */
  showLog(@required bool show) {
    _showLog=show;
  }
  static final  CLASS_NAME = "EzBloc";
  static bool _showLog=true;
  static _log(String log) {
    if (_showLog) {
      print(CLASS_NAME + ": " + log);
    }
  }

  @override 
  EzBlocBaseState get initialState => EzBlocEmptyState();

  @override
  Stream<EzBlocState> mapEventToState(EzBlocEvent event) async* { 
    
    EzBlocBaseState state = EzBlocEmptyState(); 
    if (_events.containsKey(event.eventName)) {
      Map eventMap = _events[event.eventName];
      String stateName = eventMap["callback"](event.eventName, event.map.keys.toList(), event.map);
      
      if (_states.containsKey(stateName)) { 
        state = _states[stateName];
      } else {
        _log("State " + stateName + " not found!");
      } 
    } else { 
        _log("Event " + event.eventName + " not found!");
    }
    yield state;
  }

  /**
   * ## Arguments
   * 
   *      @param context (BuildContext)
   *  
   *      @param stateHandler (Function)
   * 
   *  `stateHandler` should return `Widget` based on the `stateName` argument.
   * 
   *  ## Example
   * 
   *  ```
   *    // StatefulWidget class
   *    EzBloc ezBloc = EzBloc();
   *    
   *    @override
   *    Widget build(BuildContext, context) { 
   *      return ezBloc.EzBlocBuilder(context, (String stateName) {
   *        Color bgColor = Colors.blue;
   *        switch (stateName) {
   *          case "BUTTON_SELECTED_STATE":
   *            bgColor = Colors.blue;
   *            break;
   *          case "BUTTON_UNSELECTED_STATE":
   *            bgColor = Colors.grey;
   *            break;
   *          default: 
   *            break;
   *        }
   * 
   *        return FlatButton(onPressed: () {
   *            ezbloc.invokeEvent(selected ? "BUTTON_CLICKED")
   *        }, )
   *      });
   *    }
   *  ```
   * 
   */
  Widget EzBlocBuilder(BuildContext context, Function stateHandler) {
    return BlocBuilder(bloc: this, builder: (context, state) {
      String stateName = state.stateName;
      return stateHandler(stateName);
    },);  
  }

}

