<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.entities.Comment" %>
<%@page import="com.blogjsp.dao.CommentDao" %>

<%@ include file="header.jsp" %>
<%

    String sUserId = request.getParameter("userId");
    String sPostId = request.getParameter("postId");
    String sComment = request.getParameter("body");

    String res = "";
    if(sPostId != null){

        int userId = Integer.parseInt(sUserId);
        int postId = Integer.parseInt(sPostId);

        Comment comment = new Comment(sComment, userId, postId);

        res = CommentDao.saveComment(comment);
        response.sendRedirect("/post.jsp?postId="+postId);
    }

    out.write("<div>"+response+"</div>");
%>