<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.entities.Post" %>
<%@page import="com.blogjsp.dao.PostDao" %>
<%@page import="java.util.List" %>

<%

    String sPageN = request.getParameter("page");
    int pageN = 1;
    int postPerPage = 10;

    if(sPageN != null){
        pageN = Integer.parseInt(sPageN);
    }

    int nOfPosts = PostDao.getPostCount();

    int numberOfPages = ((int) Math.floor( nOfPosts / postPerPage)) + 1;

    List<Post> listaPosts = PostDao.getPostList(pageN, postPerPage);
%>

<% if(listaPosts.size() == 0){
    %><div class='text-center m-5'><h3 class='text-danger' style="width: 500px;">Sem posts para exibir</h3></div>
<%} %>

<% for (Post p : listaPosts) { %>
    <div class="card mt-3" style="min-width: 350px;">
        <div class="card-body">
            <h3 class="card-title"><%=p.getTitle()%></h3>
            <figcaption class="blockquote-footer pt-2">
                <%=p.getCreatedAt()%> 
            </figcaption>
            <p class="card-text fs-5"><%=p.getBody().substring(0, Math.min(p.getBody().length(), 15))%>...</p>
            <a href='post.jsp?postId=<%=p.getId()%>' class="btn btn-primary">Ler mais</a>
        </div>
    </div>
<%}%>

<div>
    <ul class="pagination  justify-content-center">
        <li class="page-item">
        <a class="page-link" href='?page=1' aria-label="Previous">
            <span aria-hidden="true">&laquo;</span>
        </a>
        </li>
        <% for (int i = 1; i <= numberOfPages; i++){ %>
            <li class="page-item"><a class="page-link" href='?page=<%=i%>'><%=i%></a></li>
        <%}%>
        <li class="page-item">
        <a class="page-link" href='?page=<%=numberOfPages%>' aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
        </a>
        </li>
    </ul>
</div>


    
