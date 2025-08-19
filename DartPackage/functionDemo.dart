import 'dart:io';
void main(){
  //String s1 = say("CUTM", "Hello");
  var s1 = say_named(msg: "\"Come to school\"", from: "CUTM");
  print(s1);
}

// POSITIONAL PARAMETERS WITH OPTIONAL PARAMETER
String say(String from, String msg, [String? device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}

// NAMED PARAMETERS
String say_named({String from = "you", String msg = "Hello"}){
  String returnVal = "$from says $msg";
  return returnVal;
}