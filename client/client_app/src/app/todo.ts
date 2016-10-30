export class Todo {
  todoId: string = '';
  content: string = '';
  done: boolean = false;

  constructor(values: Object = {}) {
    Object.assign(this, values);
  }
}
