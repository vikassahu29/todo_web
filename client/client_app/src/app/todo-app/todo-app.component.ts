import { Component, OnInit } from '@angular/core';
import {Todo} from '../todo';
import {TodoService} from '../todo.service';

@Component({
  selector: 'app-todo-app',
  templateUrl: './todo-app.component.html',
  styleUrls: ['./todo-app.component.css'],
  providers: [TodoService]
})
export class TodoAppComponent implements OnInit {

  newTodo: Todo = new Todo();
  todos: Todo[] = [];
  errorMessage: string;

  constructor(private todoService: TodoService) {
  }

  addTodo() {
    this.todoService.addTodo(this.newTodo).subscribe(
      todo => this.todos.push(todo),
      error => this.errorMessage = <any>error);
    this.newTodo = new Todo();
  }

  toggleTodoComplete(todo) {
    this.todoService.toggleTodoComplete(todo).subscribe(
      success => todo.done = !todo.done,
      error => this.errorMessage = <any>error
    );
  }

  removeTodo(todo) {
    this.todoService.deleteTodoById(todo.todoId).subscribe(
      success => this.todos = this.todos.filter(item => item.todoId !== todo.todoId),
      error => this.errorMessage = <any>error
    );
  }

  getTodos() {
    this.todoService.getAllTodos().subscribe(
      todos => this.todos = todos,
      error => this.errorMessage = <any>error);
  }

  ngOnInit() {
    this.getTodos();
  }

}
