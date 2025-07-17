import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ตั้งค่า'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('เกี่ยวกับแอพ'),
            subtitle: const Text('เวอร์ชัน 1.0.0'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('เกี่ยวกับแอพ'),
                  content: const Text('Todo List App\nเวอร์ชัน 1.0.0\n\nแอพจัดการรายการงานที่ต้องทำ'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ตกลง'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('ลบข้อมูลทั้งหมด'),
            subtitle: const Text('ลบรายการงานทั้งหมด'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ยืนยันการลบ'),
                  content: const Text('คุณต้องการลบข้อมูลทั้งหมดหรือไม่?\nการดำเนินการนี้ไม่สามารถยกเลิกได้'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ยกเลิก'),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: เพิ่มการลบข้อมูลทั้งหมด
                        Navigator.pop(context);
                      },
                      child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 