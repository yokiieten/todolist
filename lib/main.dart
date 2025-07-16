import 'package:flutter/material.dart';
import 'dart:math';
import 'todo_model.dart';
import 'todo_storage.dart';

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
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final TodoStorage _storage = TodoStorage();
  bool _isLoading = true;

  void _addTodo() async {
    if (_controller.text.isNotEmpty) {
      final newTodo = Todo(
        id: _generateId(),
        title: _controller.text,
        completed: false,
        createdAt: DateTime.now(),
      );
      
      await _storage.addTodo(newTodo);
      _loadTodos();
      _controller.clear();
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }

  void _removeTodo(int index) async {
    final todo = _todos[index];
    await _storage.deleteTodo(todo.id);
    _loadTodos();
  }

  void _toggleTodo(int index) async {
    final todo = _todos[index];
    await _storage.toggleTodo(todo.id);
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });
    
    final todos = await _storage.loadTodos();
    setState(() {
      _todos.clear();
      _todos.addAll(todos);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _todos.isEmpty
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
                          final todo = _todos[index];
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () => _toggleTodo(index),
                              child: Image.asset(
                                todo.completed 
                                  ? 'assets/images/todo_checked.png'  // รูปที่ทำเสร็จแล้ว
                                  : 'assets/images/my_todo_icon.png', // รูปที่ยังไม่ได้ทำ
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    todo.completed 
                                      ? Icons.check_box 
                                      : Icons.check_box_outline_blank,
                                    color: todo.completed ? Colors.green : Colors.grey,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.completed 
                                  ? TextDecoration.lineThrough 
                                  : TextDecoration.none,
                                color: todo.completed ? Colors.grey : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'สร้างเมื่อ: ${_formatDate(todo.createdAt)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
