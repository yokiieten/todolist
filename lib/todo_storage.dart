import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart';

class TodoStorage {
  static const String _key = 'todos';
  
  // Singleton pattern (เหมือน Core Data Stack)
  static final TodoStorage _instance = TodoStorage._internal();
  factory TodoStorage() => _instance;
  TodoStorage._internal();

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // MARK: - CRUD Operations (เหมือน Core Data)

  /// Save todos to local storage
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await _prefs;
    final todosJson = todos.map((todo) => todo.toJson()).toList();
    await prefs.setString(_key, jsonEncode(todosJson));
  }

  /// Load todos from local storage
  Future<List<Todo>> loadTodos() async {
    final prefs = await _prefs;
    final todosString = prefs.getString(_key);
    
    if (todosString == null) return [];
    
    try {
      final todosJson = jsonDecode(todosString) as List;
      return todosJson.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }

  /// Add a new todo
  Future<void> addTodo(Todo todo) async {
    final todos = await loadTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  /// Update an existing todo
  Future<void> updateTodo(Todo updatedTodo) async {
    final todos = await loadTodos();
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    
    if (index != -1) {
      todos[index] = updatedTodo;
      await saveTodos(todos);
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    final todos = await loadTodos();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }

  /// Toggle todo completion status
  Future<void> toggleTodo(String id) async {
    final todos = await loadTodos();
    final index = todos.indexWhere((todo) => todo.id == id);
    
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(completed: !todo.completed);
      await saveTodos(todos);
    }
  }

  /// Clear all todos
  Future<void> clearAllTodos() async {
    final prefs = await _prefs;
    await prefs.remove(_key);
  }

  // MARK: - Query Methods (เหมือน Core Data Fetch Request)

  /// Get completed todos only
  Future<List<Todo>> getCompletedTodos() async {
    final todos = await loadTodos();
    return todos.where((todo) => todo.completed).toList();
  }

  /// Get incomplete todos only
  Future<List<Todo>> getIncompleteTodos() async {
    final todos = await loadTodos();
    return todos.where((todo) => !todo.completed).toList();
  }

  /// Get todos by date range
  Future<List<Todo>> getTodosByDateRange(DateTime start, DateTime end) async {
    final todos = await loadTodos();
    return todos.where((todo) => 
      todo.createdAt.isAfter(start) && todo.createdAt.isBefore(end)
    ).toList();
  }

  /// Get todos sorted by creation date
  Future<List<Todo>> getTodosSortedByDate({bool ascending = true}) async {
    final todos = await loadTodos();
    todos.sort((a, b) => ascending 
      ? a.createdAt.compareTo(b.createdAt)
      : b.createdAt.compareTo(a.createdAt)
    );
    return todos;
  }
} 