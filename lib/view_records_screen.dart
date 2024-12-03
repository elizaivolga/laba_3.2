import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class ViewRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Таблица одногруппников')),
      body: FutureBuilder(
        future: DatabaseHelper().getAllRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            var records = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                var record = records[index];
                return ListTile(
                  title: Text('${record['surname']} ${record['name']} ${record['patronymic']}'),
                  subtitle: Text('ID: ${record['id']} | Время: ${record['time_added']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
