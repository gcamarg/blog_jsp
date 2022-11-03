package com.blogjsp.entities;

import java.sql.Timestamp;
import java.util.List;

public class Post {

    private int id;
    private String title;
    private String body;
    private Timestamp createdAt;
    private int userId;

    private List<Comment> commentList;
    public Post() {
    }

    public Post(String title, String body, Timestamp createdAt, int userId) {
        this.title = title;
        this.body = body;
        this.createdAt = createdAt;
        this.userId = userId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public List<Comment> getCommentList() {
        return commentList;
    }

    public void setCommentList(List<Comment> commentList) {
        this.commentList = commentList;
    }
}
