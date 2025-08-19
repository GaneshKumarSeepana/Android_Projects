import 'dart:io';
import 'dart:math';
void main(){
  int no_lines = 10;
  for(int i = 0; i < no_lines; i++) {
    print('*'*(no_lines - i)+ ' '*2*i + '*'*(no_lines - i));
  }
  for(int i = 2; i <= no_lines; i++){
    print('*'*(i) + ' '*2*(no_lines-i) + '*'*(i));
  }
  //METHOD 3
  var numbers = [2,3,5,9,10];
  print("Iteration over the list by using collections.foreach\n "+"*"*30);
  numbers.forEach((var num)=> print(num));

  //METHOD 2
  print("Iterate over the list using for..in loop\n"+"x"*25);
  for (int i in numbers){
    print(i);
  }
  //METHOD 1
  print("number of elements in the list are: ${numbers.length}");
  for(int i = 0; i < numbers.length; i++){
    print(numbers.elementAt(i));
  }
  print("Enter your name:");
  var name = stdin.readLineSync();

  print("Enter a number:");
  int? number = int.parse(stdin.readLineSync()!);

  print("Enter your name1:");
  var name1 = stdin.readLineSync();
  print("Entered name is $name1");

  int numb1 = 0;
  print("Enter a number:");
  String? number1 = stdin.readLineSync();
  if (number1!.isNotEmpty)
    numb1 = int.parse(number1!);
  print("Number entered is $numb1");


}


