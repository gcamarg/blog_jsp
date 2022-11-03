<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.dao.CommentDao" %>

<%@ include file="header.jsp" %>
<%

    String sCommentId = request.getParameter("commentId");
    String sPostId = request.getParameter("postId");
    String res = "";
    if(sCommentId != null){

        int commentId = Integer.parseInt(sCommentId);
        res = CommentDao.deleteComment(commentId);
        response.sendRedirect("/post.jsp?postId="+sPostId);
    }

    out.write("<div>"+response+"</div>");
%>