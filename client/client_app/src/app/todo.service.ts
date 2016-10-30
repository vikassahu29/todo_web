import {Injectable} from '@angular/core';
import {Todo} from './todo';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Observable }     from 'rxjs/Observable';

@Injectable()
export class TodoService {

  todos: Todo[] = [];

  constructor(private http: Http) {
  }

  addTodo(todo: Todo): Observable<Todo> {
    let headers = new Headers({ 'Content-Type': 'application/json' });
    let options = new RequestOptions({ headers: headers });
    return this.http.post("http://localhost:3000/todos", todo, options)
                    .map(this.extractData)
                    .catch(this.handleError);
  }


  deleteTodoById(id: string): Observable<any> {
    return this.http.delete("http://localhost:3000/todos/" + id)
                    .map(this.extractData)
                    .catch(this.handleError);

  }

  getAllTodos(): Observable<Todo[]> {
    return this.http.get("http://localhost:3000/todos")
                    .map(this.extractData)
                    .catch(this.handleError);
  }

  private extractData(res: Response) {
    let body = res.json();
    return body || { };
  }

  private handleError (error: Response | any) {
    let errMsg: string;
    if (error instanceof Response) {
      const body = error.json() || '';
      const err = body.error || JSON.stringify(body);
      errMsg = `${error.status} - ${error.statusText || ''} ${err}`;
    } else {
      errMsg = error.message ? error.message : error.toString();
    }
    console.error(errMsg);
    return Observable.throw(errMsg);
  }

  getTodoById(id: string): Todo {
    return this.todos
      .filter(todo => todo.todoId === id)
      .pop();
  }

  toggleTodoComplete(todo: Todo): Observable<any>{
    let tempTodo = new Todo();
    Object.assign(tempTodo, todo)
    tempTodo.done = !tempTodo.done;
    return this.http.put("http://localhost:3000/todos/" + todo.todoId, tempTodo)
                    .map(this.extractData)
                    .catch(this.handleError)
  }

}
