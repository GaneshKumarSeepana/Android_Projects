import 'dart:io';
Future<void> main() async{
  //File handling
  //READING FROM FILE
  var someFile = File('inputData.txt');
  if (await someFile.exists()){
    print ("File exists\nContents\n" + '='*40);
    String contents = someFile.readAsStringSync();
    print(contents);
    print("="*40);
  } else {
    print('File does not exist');
  }



  var some_File = File('inputData.txt');
  if (await someFile.exists()){
    print ("File exists\nContents\n" + '='*40);
    var contents = someFile.readAsLinesSync();
    for (String line in contents)
      print(line);
    print("="*40);
  } else {
    print('File does not exist');
  }

  //CREATING LOG FILE
  var someFile2 = File('inputData.txt');
  var logFile = File('log.txt');
  IOSink stream;

  //OPENING FILE TO WRITE THE LOG DATA
  if (logFile.existsSync()){
    stream = logFile.openWrite(mode: FileMode.append);
  }else{
    stream = logFile.openWrite();
  }
  var someFile1 = File('inputData.txt');
  if(await someFile.exists()){
    print("File exists\nContents\n" + '='*40);
    var contents = someFile.readAsLinesSync();
    contents.forEach((line) => print(line));
    print("="*40);
    stream.write("${DateTime.now()}: File opened");
  } else {
    print("File does not exist");
  }

  await stream.flush();
  await stream.close();

    //DIRECTORY LISTING
    var dir = Directory('.');
    try{
      var file_list = dir.list();
      await for (FileSystemEntity f in file_list){
        if(f is File){
          print(f.path);
        }
      }
    }catch(e){
      print(e.toString());
    }
  }


 /*
  int a = 10;
  double b = 20;
  double c = a + b;
  //c=30.0 is required output
  String str = "c=${a+b}";
  print("c=$c");
  print("c=${a+b}");
  print(str.length);
  print(str[0]);

  //c= in one line and 30.0 in the other
  print("c=");
  print(c);

  //printing 5 * continuously
  print("*"*5);

  String str1 = "Name";
  String str2 = "Name";
  print(str1 == str2);

  bool b1 = true;

  List<int> var_name1 = List<int>.filled(5, 0);
  print(var_name1);
  List<int> numbers = List.generate(5, (index) => index*index);
  print(numbers);

  numbers.add(100);
  numbers.add(200);
  //numbers.clear();
  print(numbers.elementAt(1));

  print(var_name1 + numbers);


  for (int i = 0; i < 26; i++) {
    String stars = "*" * (26 - i);
    String spaces = ' ' * (i * 2);
    if (i == 0) {
      print(stars);
    } else {
      print(stars + spaces + stars);

    }
  }
  for(int i = 1; i < 26; i++) {
    String stars = "*" * (i + 1);
    String spaces = ' ' * ((26 - 1 - i) * 2);
    if ((26 - 1 - i == 0)) {
      print(stars + ' ' + stars);
    } else {
      print(stars + spaces + stars);
    }
  }

  int z = 5; // First term
  int r = 5; // Common ratio
  int numberOfTerms = 15;

  print("First $numberOfTerms elements of the geometric progression:");
  print("z = $z, r = $r");
  print("------------------------------------");

  int currentTerm = z;

  for (int i = 0; i < numberOfTerms; i++) {
    print("Term ${i + 1}: $currentTerm");
    currentTerm *= r; // Calculate the next term
  }




  int no_lines = 0;
  print("Enter a number:");
  String? number = stdin.readLineSync();
  if(number!.isNotEmpty){
    no_lines = int.parse(number!);
    print("Number entered is $no_lines");
    print('-'*no_lines);
    print('#'*no_lines);
    print('-'*no_lines);
  }
  //int no_lines = 10;
  for (int i = 0; i < no_lines; i++){
    print('*'*(no_lines-i)+ ' '*2*i + '*'*(no_lines-i) + "*"*(no_lines-i) + ' '*2*i + ' '*2*i + '*'*(no_lines-i));
  }
  for (int i = 0; i < no_lines; i++){
    print("*"*(i) + ' '*2*(no_lines-i) + "*"*(i));
  }*/
