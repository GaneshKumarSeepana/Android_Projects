import 'dart:convert';
import 'dart:io';

// ABSTRACT PERSON CLASS
abstract class Person {
  final String _name;
  late String gender;
  late String work;

  // Default constructor
  Person(this._name, {String gender = "male"}) {
    this.gender = gender;
  }

  // Named constructors
  Person.male(this._name) {
    gender = "male";
  }

  Person.female(this._name) {
    gender = "female";
  }

  void setWork(String work);
  String getWork();
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// CONCRETE CLASS IMPLEMENTING PERSON
class SoftwareEngineer implements Person {
  final String name;
  @override
  late String gender;
  @override
  late String work;

  SoftwareEngineer(this.name, {this.gender = "male"});

  @override
  void setWork(String work) {
    this.work = work;
  }

  @override
  String getWork() => work;

  @override
  String greet(String who) => "Hello $who! I'm $name, working as $work.";

  @override
  String get _name => name;
}

// CLASS WITH MIXINS
class A {
  void printNameOfClass() {
    print('Class name is A');
  }
}

mixin B on A {
  @override
  void printNameOfClass() {
    print('Class name is B');
  }
}

mixin C on A {
  @override
  void printNameOfClass() {
    print('Class name is C');
  }
}

class D extends A with C, B {} // B overrides C

// CLASS FOR USER INTERACTION
class PersonData {
  late String _name;
  late final String _gender;
  double _age;
  String _job = "NA";
  String _org = "NA";

  PersonData(this._name, this._gender, this._age);

  PersonData.male(this._name, this._age) {
    _gender = "male";
  }

  PersonData.female(this._name, this._age) {
    _gender = "female";
  }

  String greet(String personName) => "Hello $personName! I am $_name";

  String get job => _job;
  set job(String work) => _job = work;

  void setEmploymentData({Map<String, String>? map, List<String>? data}) {
    if (map != null && data != null) {
      throw ArgumentError("Error: Provide either a map or a list, not both.");
    } else if (map != null) {
      _job = map['job'] ?? "Not Specified";
      _org = map['org'] ?? "Not Specified";
    } else if (data != null) {
      if (data.length >= 2) {
        _job = data[0];
        _org = data[1];
      } else {
        throw ArgumentError("Error: List must contain at least 2 elements (job, org).");
      }
    }
  }

  String get organization => _org;
}

// FETCH JSON FROM URL
Future<void> fetchAlbum() async {
  final int albumId = 1;
  String end = 'https://jsonplaceholder.typicode.com/albums/$albumId';
  final Uri url = Uri.parse(end);
  print('Attempting to connect to: $url');

  try {
    final HttpClient client = HttpClient();
    client.findProxy = (uri) => 'DIRECT';

    final HttpClientRequest request = await client.getUrl(url);
    final HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final String responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> album = jsonDecode(responseBody);

      print('\nAlbum Data:');
      print('ID: ${album['id']}');
      print('User ID: ${album['userId']}');
      print('Title: ${album['title']}');
    } else {
      print('Failed to load album. Status code: ${response.statusCode}');
    }

    client.close();
  } catch (e, s) {
    print('An error occurred: $e');
    print('Stack trace:\n$s');
  }
}

// MAIN FUNCTION
Future<void> main() async {
  // OOP User Interaction Part
  stdout.write("Enter name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter gender (male/female): ");
  String? gender = stdin.readLineSync();

  stdout.write("Enter age: ");
  double age = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

  PersonData p = PersonData(name ?? "Unnamed", gender ?? "Unknown", age);

  stdout.write("Do you want to pass data as (map/list/none)? ");
  String? choice = stdin.readLineSync()?.toLowerCase();

  try {
    if (choice == "map") {
      stdout.write("Enter job: ");
      String? job = stdin.readLineSync();
      stdout.write("Enter organization: ");
      String? org = stdin.readLineSync();

      p.setEmploymentData(map: {
        'job': job ?? "Not Specified",
        'org': org ?? "Not Specified",
      });
    } else if (choice == "list") {
      stdout.write("Enter job: ");
      String? job = stdin.readLineSync();
      stdout.write("Enter organization: ");
      String? org = stdin.readLineSync();

      p.setEmploymentData(data: [
        job ?? "Not Specified",
        org ?? "Not Specified",
      ]);
    } else if (choice != "none") {
      print("Invalid choice. Choose either 'map', 'list', or 'none'.");
    }

    print("\n--- Person Summary ---");
    print(p.greet("Friend"));
    print("Job: ${p.job}");
    print("Organization: ${p.organization}");
  } catch (e) {
    print("Exception caught: $e");
  }

  // Mixins Demo
  print("\n--- Mixin Class Demo ---");
  D d = D();
  d.printNameOfClass(); // Outputs from mixin B

  // Interface Demo
  print("\n--- Interface Implementation ---");
  SoftwareEngineer se = SoftwareEngineer("Ajay");
  se.setWork("Software Developer");
  print(se.greet("Team"));

  // API JSON Fetch Demo
  print("\n--- Fetching Album from API ---");
  await fetchAlbum();
}
