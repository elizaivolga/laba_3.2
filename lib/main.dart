import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'view_records_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Очистить базу данных при запуске приложения
  await _clearDatabase();

  runApp(MyApp());
}

Future<void> _clearDatabase() async {
  // Очищаем данные в базе при каждом запуске
  await DatabaseHelper().clearDatabase();

  // Можно, например, затем вставить 5 записей (если требуется)
  await DatabaseHelper().addRecord('Рыжков Алексей Святославович');
  await DatabaseHelper().addRecord('Тамбовцева Наталья Тимофеевна');
  await DatabaseHelper().addRecord('Петров Павел Павлович');
  await DatabaseHelper().addRecord('Сидоров Сергей Станиславович');
  await DatabaseHelper().addRecord('Михайлов Максим Мирославович');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главный экран')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRecordsScreen()),
                );
              },
              child: Text('Показать таблицу'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Передаем фамилию, имя и отчество как одну строку
                await DatabaseHelper().addRecord('Новый Одногруппник И.');
              },
              child: Text('Добавить запись'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().updateLastRecord();
              },
              child: Text('Обновить последнюю запись'),
            ),
          ],
        ),
      ),
    );
  }
}
