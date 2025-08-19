import 'dart:io';
Future<void> main() async {
  print("Hello world!!!");
  print("I am writing my first dart file");


// WORKING WITH NUMBERS
  int a = 10; //int? a;
  double b = 20.0;
  num c = a + b; // num c = a! + b;
  print("a+b = ${a + b}");

  /*int a = 10;
  double b = 20.0;
  try {
    num c = a! + b;
    print("a+b = ${a + b}");
    print(b.floor());
    print(b.truncate());
    print(b.round());
  }catch(e,s){
    print(e);
    print(s);
  }*/

  //DECLARING AND WORKING WITH STRINGS
  String s1 = "Hello";
  String s2 = "World!!";
  String s3 = s1 + s2;
  print(s3);

  // WORKING WITH BOOLEANS
  bool b1 = (s1 == s2);
  print(b1);

  // WORKING WITH LISTS
  List<int> myList = [1, 2, 3, 4];
  myList.add(1);
  print(myList);

  Set<int> mySet = {1, 2, 3, 4};
  mySet.add(1); // SET DOESN'T ACCEPT DUPLICATE VALUES
  print(mySet);


  // print(myList + mySet.toList());

  Map<String, int> myMap = {
    "Ajay": 100,
    "Rajeev": 100,
    "Vinay": 0
  };
  var name = "Ajay";
  print("% of classes $name is absent: ${myMap["Ajay"]}");

  // WORKING WITH LOOPING STATEMENTS
  // ITERATING OVER LIST
  int list_size = myList.length;
  print('-' * 15 + "\n for loop" + '-' * 15); // FOR LOOP
  for (int i = 0; i < list_size; i++) {
    print(myList[i]);
  }

  print('-' * 15 + "\n for..in loop" + '-' * 15);
  for (int item in myList) { // FOR..INLOOP
    print(item);

    print('-' * 15 + "\n for..Each loop" + '-' * 15);
    myList.forEach((item) => print(item)); // FOR..EACH LOOP


    // ITERATING OVER MAPS
    var keys = myMap.keys;
    print(keys);
    keys.toList().forEach((item) => print(myMap[item]));
  }

  myMap.forEach((key, value) {
    print("$key : $value");
  });

  // WHILE LOOP

  print('-' * 15 + "\n while loop" + '-' * 15);
  int i = 0;
  while (i < myList.length) {
    print(myList[i]);
    i++;
  }

  // DO WHILE LOOP
  print('-' * 15 + "\n do while loop" + '-' * 15);
  i = 0;
  do {
    print(myList[i]);
    i++;
  } while (i < myList.length);


  // I/O operations
  //READING DATA FROM CONSOLE
  String? lin_count;
  try {
    print("Enter the number of lines:");
    lin_count = stdin.readLineSync();
    var count = int.parse(lin_count!);
    if (count.isOdd) {
      count++;
    }
    for (int i = 0; i < count; i++) {
      print('*' * (count - i) + ' ' * 2 * i + '*' * (count - i));
    }
    for (int i = 2; i < count; i++) {
      print('*' * i + ' ' * 2 * (count - i) + '*' * i);
    }
  } catch (e, s) {
    print("Exception generated is $e");
    print(s);
  }

  //READING AND WRITING FILES

  //READING AS A SINGLE STRING
  File inp_file = File("inputData.txt");
  String contents = inp_file.readAsStringSync();
  print(contents);

  //READING THE DATA AS A LIST OF STRINGS
  var data = inp_file.readAsLinesSync();
  data.forEach((line) => print(line));

  File out_file = File('outputData.txt');
  IOSink ios = out_file.openWrite(mode: FileMode.append);
  //ios.write(contents);
  data.forEach((line) => ios.write(line));
  await ios.flush();
  await ios.close();

  // WORKING WITH Directory CLASS
  print('-' * 15 + "\n working with directory class\n" + '-' * 15);

  var dir = Directory('.');
  var dirList = dir.list();

  dirListing(dirList, 0);
}

Future<void> dirListing(Stream<FileSystemEntity> fl, int indent) async {
  await for (var fse in fl) {
    if (fse is Directory) {
      // No indentation for directories
      print("Directory: ${fse.path}");
      await dirListing(Directory(fse.path).list(), indent + 1);
    } else if (fse is File) {
      // Indent only files
      final tab = '\t' * indent;
      print("${tab}File: ${fse.path}");
    }
  }

}

