package com.example.demo.controller;

import com.example.demo.model.Todo;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/todos")
public class ToDoController {
    private final List<Todo> todos = new ArrayList<>();
    private int idCounter = 1;

    @PostMapping
    public Todo addTodo(@RequestParam String task) {
        Todo newTodo = new Todo(idCounter++, task);
        todos.add(newTodo);
        return newTodo;
    }

    @GetMapping
    public List<Todo> getTodos() {
        return todos;
    }

    @DeleteMapping("/{id}/complete")
    public String completeTodo(@PathVariable int id) {
        for(Todo todo : todos) {
            if (todo.getId() == id) {
                todo.setComplete(true);
                return "Todo marked complete";
            }
        }
        return "Todo not found";
    }
}
