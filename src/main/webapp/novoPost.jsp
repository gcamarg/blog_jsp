<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.entities.Post" %>
<%@page import="com.blogjsp.dao.PostDao" %>
<%@page import="com.blogjsp.entities.User" %>
<%@ include file="header.jsp" %>

<%

    User thisUser = User.class.cast(request.getSession().getAttribute("logUser"));
    boolean isAdmin = false;
    boolean isLogged = false;
    if( thisUser != null){
        isAdmin = thisUser.isAdmin();
        isLogged = true;
    }

    if(request.getMethod() == "POST" && isAdmin){
        String sTitle = request.getParameter("title");
        String sBody = request.getParameter("body");

        Post newPost = new Post();

        newPost.setTitle(sTitle);
        newPost.setBody(sBody);
        newPost.setUserId(thisUser.getId());
        PostDao.savePost(newPost);
        response.sendRedirect("/");
    }

%>


<div class="card m-3 me-4" style="min-width: 350px;">
    <div class="card-body" >
        <% if(isLogged && isAdmin){%>
            <form action="novoPost.jsp" method="POST" class="m-3" id="novoPost">
                <div class="mb-3">
                    <label for="area-titulo" class="form-label">Título</label>
                    <input type="text" class="form-control" name="title" id="area-titulo" maxlength="500"></input>
                </div>
                <div class="mb-3">
                    <label for="area-post" class="form-label">Texto</label>
                    <textarea class="form-control" name="body" id="area-post" rows="10" maxlength="2000"></textarea>
                </div>
                <button onclick="postar()" class="btn btn-success">Postar</button>
                <a type="button" href="/" class="btn btn-danger">Cancelar</a>
            </form>
        <%} else {%>
            <div>Você precisa estar logado para comentar. <a href="login.jsp">Clique aqui</a> para fazer login.</div>
        <%}%>
            
    </div>
    
    <script>
    </script>
</div>