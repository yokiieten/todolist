import 'package:flutter/material.dart';
import '../todo_model.dart';
import '../todo_storage.dart';
import '../test_page.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final List<Todo> _completedTodos = [];
  final TodoStorage _storage = TodoStorage();
  bool _isLoading = true;

  Future<void> _loadCompletedTodos() async {
    setState(() {
      _isLoading = true;
    });
    
    final todos = await _storage.loadTodos();
    setState(() {
      _completedTodos.clear();
      _completedTodos.addAll(todos.where((todo) => todo.completed));
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCompletedTodos();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('งานที่เสร็จแล้ว'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _completedTodos.isEmpty
              ? const Center(
                  child: Text(
                    'ยังไม่มีงานที่เสร็จแล้ว',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _completedTodos.length,
                  itemBuilder: (context, index) {
                    final todo = _completedTodos[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                      title: Text(
                        todo.title,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        'เสร็จเมื่อ: ${_formatDate(todo.createdAt)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestPage(todo: todo),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
} 