package com.example.demo.model;

public class Todo {
    private int id;
    private String task;
    private boolean complete;

    public Todo(int id, String task) {
        this.id = id;
        this.task = task;
        this.complete = false;
    }

    public int getId() { return id; }

    public String getTask() { return task; }

    public boolean isComplete() { return complete; }

    public void setComplete(boolean complete) { this.complete = complete; }
}
