<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.dao.PostDao" %>

<%

    String sPostId = request.getParameter("postId");
    int postId = 0;
    if(sPostId != null){
        postId = Integer.parseInt(sPostId);
    }

    if(request.getMethod() == "POST"){
        out.write("<script>console.log('teste')</script>");
        PostDao.deletePost(postId);
        response.sendRedirect("/");
    }
%>