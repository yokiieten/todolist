import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _todos = [];
  final List<bool> _completed = []; // เพิ่มสถานะการทำเสร็จ
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
        _completed.add(false); // เพิ่มสถานะเริ่มต้นเป็น false
        _controller.clear();
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _completed.removeAt(index); // ลบสถานะด้วย
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _completed[index] = !_completed[index]; // สลับสถานะ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          // Input section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: 
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'เพิ่มงานที่ต้องทำ...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('เพิ่ม'),
                ),
              ],
            ),
          ),
          // Todo list
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Text(
                      'ยังไม่มีงานที่ต้องทำ\nลองเพิ่มงานใหม่ดูสิ!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () => _toggleTodo(index),
                          child: Image.asset(
                            _completed[index] 
                              ? 'assets/images/todo_checked.png'  // รูปที่ทำเสร็จแล้ว
                              : 'assets/images/my_todo_icon.png', // รูปที่ยังไม่ได้ทำ
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                _completed[index] 
                                  ? Icons.check_box 
                                  : Icons.check_box_outline_blank,
                                color: _completed[index] ? Colors.green : Colors.grey,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          _todos[index],
                          style: TextStyle(
                            decoration: _completed[index] 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                            color: _completed[index] ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTodo(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
