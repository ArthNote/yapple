//create a list of json objects of modules
import 'package:flutter/material.dart';

const modules = [
  {
    "moduleName": "Mobile & Web Technologies",
    "moduleCode": "CS5007",
    "moduleCategory": "Coding",
    "isStarred": true,
    "color": Colors.blue,
  },
  {
    "moduleName": "Object oriented programming",
    "moduleCode": "CS5011",
    "moduleCategory": "Coding",
    "isStarred": true,
    "color": Color.fromARGB(255, 249, 112, 110),
  },
  {
    "moduleName": "Introduction to Marketing",
    "moduleCode": "BF1005",
    "moduleCategory": "Business",
    "isStarred": true,
    "color": Color.fromARGB(255, 84, 209, 89),
  },
  {
    "moduleName": "Working in teams",
    "moduleCode": "BL1011",
    "moduleCategory": "Business",
    "isStarred": true,
    "color": Color.fromARGB(255, 167, 88, 216),
  },
  {
    "moduleName": "Mobile & Web Technologies",
    "moduleCode": "CS5007",
    "moduleCategory": "Coding",
    "isStarred": true,
    "color": Colors.blue,
  },
  {
    "moduleName": "Object oriented programming",
    "moduleCode": "CS5011",
    "moduleCategory": "Coding",
    "isStarred": true,
    "color": Color.fromARGB(255, 249, 112, 110),
  },
  {
    "moduleName": "Introduction to Marketing",
    "moduleCode": "BF1005",
    "moduleCategory": "Business",
    "isStarred": true,
    "color": Color.fromARGB(255, 84, 209, 89),
  },
  {
    "moduleName": "Working in teams",
    "moduleCode": "BL1011",
    "moduleCategory": "Business",
    "isStarred": true,
    "color": Color.fromARGB(255, 167, 88, 216),
  },
];

const students = [
  {
    "name": "John Doe",
    "email": "jdoe@me.com",
  },
  {
    "name": "Jane Doe",
    "email": "jdoe@me.com",
  },
  {
    "name": "Adam Doe",
    "email": "jdoe@me.com",
  },
];

const quizz = [
  {
    'title': "who's the best player in 2023",
    'answers': [
      {'answer': "messi", 'correct': true},
      {'answer': "ronaldo", 'correct': false},
      {'answer': "you", 'correct': false},
    ]
  },
  {
    'title': "who's the worst player in 2023",
    'answers': [
      {'answer': "you", 'correct': true},
      {'answer': "ziach", 'correct': false},
      {'answer': "rahimi", 'correct': false}
    ]
  },
  {
    'title': "best programming language is",
    'answers': [
      {'answer': "flutter", 'correct': true},
      {'answer': "python", 'correct': false},
      {'answer': "php", 'correct': false}
    ]
  },
];

const questions = [
  {
    'question': '1. What is the capital of France?',
    'correctAnswerIndex': 1,
    'options': [
      'a) Madrid',
      'b) Paris',
      'c) Berlin',
      'd) Rome',
    ],
  },
  //generate more questions
  {
    'question': '2. What is the capital of Spain?',
    'correctAnswerIndex': 0,
    'options': [
      'a) Madrid',
      'b) Paris',
      'c) Berlin',
      'd) Rome',
    ],
  },
  {
    'question': '3. What is the capital of Germany?',
    'correctAnswerIndex': 2,
    'options': [
      'a) Madrid',
      'b) Paris',
      'c) Berlin',
      'd) Rome',
    ],
  },
  {
    'question': '4. What is the capital of Italy?',
    'correctAnswerIndex': 3,
    'options': [
      'a) Madrid',
      'b) Paris',
      'c) Berlin',
      'd) Rome',
    ],
  }
];

const submissions = [
  {
    'name': 'John Doe',
    'date': 'Sun 21 april 2024',
    'graded': false,
    'grade': 0,
    'time': '12:00 PM',
    'files': [
      'file1.pdf',
      'file2.pdf',
      'file3.pdf',
    ],
    'comment': '',
  },
  {
    'name': 'Jane Doe',
    'date': 'Sun 21 april 2024',
    'graded': true,
    'grade': 83,
    'time': '12:00 PM',
    'files': [
      'file1.pdf',
      'file2.pdf',
      'file3.pdf',
    ],
    'comment':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut purus eget sapien.',
  },
  {
    'name': 'Adam Doe',
    'date': 'Sun 21 april 2024',
    'graded': true,
    'grade': 52,
    'time': '12:00 PM',
    'files': [
      'file1.pdf',
      'file2.pdf',
      'file3.pdf',
    ],
    'comment':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut purus eget sapien.',
  },
];
