import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Quiz App',
      home: QuestionScreen(index: 0),
    );
  }
}

// Question Data Model
class Question {
  final String questionText;
  final List<String> options;
  final bool isMultipleChoice;

  Question({
    required this.questionText,
    required this.options,
    this.isMultipleChoice = false,
  });
}

// Global State for Quiz
class QuizState {
  static final Map<int, dynamic> answers = {};
}

// 10 Feedback Questions
final List<Question> questions = [
  Question(
    questionText: "How satisfied are you with the app's performance?",
    options: ['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied'],
  ),
  Question(
    questionText: "What features do you use the most?",
    options: ['Chat', 'Search', 'Notifications', 'Profile'],
    isMultipleChoice: true,
  ),
  Question(
    questionText: "Is the UI intuitive?",
    options: ['Yes', 'No'],
  ),
  Question(
    questionText: "Which themes do you prefer?",
    options: ['Light', 'Dark', 'System Default'],
    isMultipleChoice: true,
  ),
  Question(
    questionText: "How would you rate the customer support?",
    options: ['Excellent', 'Good', 'Average', 'Poor'],
  ),
  Question(
    questionText: "Which devices do you use the app on?",
    options: ['Mobile', 'Tablet', 'Desktop'],
    isMultipleChoice: true,
  ),
  Question(
    questionText: "Do you recommend the app to others?",
    options: ['Yes', 'No'],
  ),
  Question(
    questionText: "Which app section needs improvement?",
    options: ['Home', 'Settings', 'Profile', 'Support'],
    isMultipleChoice: true,
  ),
  Question(
    questionText: "How often do you use the app?",
    options: ['Daily', 'Weekly', 'Monthly', 'Rarely'],
  ),
  Question(
    questionText: "What features would you like to see in future?",
    options: ['Voice Commands', 'Dark Mode', 'Faster Load Time', 'More Languages'],
    isMultipleChoice: true,
  ),
];

// Shared Question Screen
class QuestionScreen extends StatefulWidget {
  final int index;
  const QuestionScreen({super.key, required this.index});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  dynamic selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = QuizState.answers[widget.index] ?? (isMultiple ? <String>[] : null);
  }

  bool get isMultiple => questions[widget.index].isMultipleChoice;

  void _onSingleSelect(String? value) {
    setState(() {
      selectedAnswer = value;
      QuizState.answers[widget.index] = value;
    });
  }

  void _onMultiSelect(String value, bool selected) {
    setState(() {
      List<String> current = List<String>.from(selectedAnswer ?? []);
      if (selected) {
        current.add(value);
      } else {
        current.remove(value);
      }
      selectedAnswer = current;
      QuizState.answers[widget.index] = current;
    });
  }

  void _nextQuestion() {
    if (widget.index < questions.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuestionScreen(index: widget.index + 1)),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
    }
  }

  void _prevQuestion() {
    Navigator.pop(context);
  }

  bool get isValidAnswer {
    if (isMultiple) {
      return selectedAnswer != null && (selectedAnswer as List).isNotEmpty;
    } else {
      return selectedAnswer != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[widget.index];
    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${widget.index + 1}/10"),
        leading: widget.index > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _prevQuestion)
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.questionText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...question.options.map((option) {
              if (isMultiple) {
                return CheckboxListTile(
                  title: Text(option),
                  value: (selectedAnswer as List<String>).contains(option),
                  onChanged: (bool? selected) =>
                      _onMultiSelect(option, selected ?? false),
                );
              } else {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedAnswer,
                  onChanged: _onSingleSelect,
                );
              }
            }).toList(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.index > 0)
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    child: const Text("Previous"),
                  ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isValidAnswer ? _nextQuestion : null,
                  child: Text(widget.index == questions.length - 1 ? "Submit" : "Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Final Result Screen
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (_, i) {
          final question = questions[i];
          final answer = QuizState.answers[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Q${i + 1}: ${question.questionText}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Your Answer: ${answer is List ? answer.join(', ') : answer}"),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
