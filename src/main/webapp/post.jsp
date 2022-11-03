<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.entities.Post" %>
<%@page import="com.blogjsp.dao.PostDao" %>
<%@page import="com.blogjsp.entities.User" %>
<%@page import="com.blogjsp.dao.UserDao" %>
<%@page import="com.blogjsp.entities.Comment" %>
<%@page import="java.util.List" %>

<%

    User thisUser = User.class.cast(request.getSession().getAttribute("logUser"));
    boolean isAdmin = false;
    boolean isLogged = false;
    if( thisUser != null){
        isAdmin = thisUser.isAdmin();
        isLogged = true;
    }

    String sPostId = request.getParameter("postId");
    int postId = 0;
    if(sPostId != null){
        postId = Integer.parseInt(sPostId);
    }

    Post post = PostDao.getOnePost(postId);
    List<Comment> commentList = post.getCommentList();
    String user = UserDao.findUserNameById(post.getUserId());
    
    

    if(request.getMethod() == "POST"){
        String sTitle = request.getParameter("title");
        String sBody = request.getParameter("body");

        Post editedPost = new Post();
        editedPost.setId(postId);
        editedPost.setTitle(sTitle);
        editedPost.setBody(sBody);

        PostDao.updatePost(editedPost);
        response.sendRedirect("/post.jsp?postId="+postId);
    }
%>

<%@ include file="header.jsp" %>
<div class="card m-3 me-4" style="min-width: 350px;">
    <div class="card-body" >
        <div id="post-card">
            <h3 class="card-title" id="post-title"><%=post.getTitle()%></h3>
            <figcaption class="blockquote-footer pt-2">
                <%=user%> at <%=post.getCreatedAt()%> 
            </figcaption>
            <p class="card-text fs-5" id="post-body"><%=post.getBody()%></p>
        </div>
        <% if( isAdmin ){ %>
            <form action="post.jsp" method="POST" class="m-3" id="edit-form" hidden>
                <div class="mb-3">
                    <label for="area-titulo" class="form-label">Título</label>
                    <input type="text" class="form-control" name="title" id="area-titulo" maxlength="500" value='<%=post.getTitle()%>'></input>
                </div>
                <div class="mb-3">
                    <label for="area-post" class="form-label">Texto</label>
                    <textarea class="form-control" name="body" id="area-post" rows="6" maxlength="2000"><%=post.getBody()%></textarea>
                </div>
                <button type="button" onclick="alterarPost()" class="btn btn-success">Alterar</button>
                <button type="button" onclick="cancelar()" class="btn btn-danger">Cancelar</button>
            </form>
            <div class="m-3 admin-approval">
                <button class="btn btn-link" onclick='editarPost()'>Editar</button>
                <button class="btn btn-danger" onclick='deletarPost()'>Deletar</button>
            </div>  
        <%}%>   
    </div>
</div>

<div class="card m-3 me-4" style="min-width: 350px;">
    <div class="card-header text-primary text-center">
        <h4 class="text-primary text-center">Comentários</h4>
    </div>
    <% for (Comment c : commentList) {
        boolean approved = c.isApproved();
        if(approved || isAdmin ){ %>
        <div class="card-body">
            <h5 class="card-title"><%=c.getUserEmail()%></h5>
            <figcaption class="blockquote-footer pt-2">
                <%=c.getCreatedAt()%> 
            </figcaption>
            <p class="card-text fs-5"><%=c.getBody()%></p>    
            <%} if( isAdmin && !approved ){ %>
                <div class="ms-2 admin-approval">
                    <button class="btn btn-success" onclick="moderarComentario(<%=c.getId()%>, 'approveComment.jsp')">Aprovar</button>
                    <button class="btn btn-danger" onclick="moderarComentario(<%=c.getId()%>, 'deleteComment.jsp')">Deletar</button>
                </div>  
            <%}%>
        </div>
        <hr />
    <%}%>
    <% if(isLogged){%>
        <form action="comment.jsp" method="POST" id="form-comentario" class="m-3">
        <div class="mb-3">
        <label for="area-comentario" class="form-label">Comentário</label>
        <textarea class="form-control" name="body" id="area-comentario" rows="4" maxlength="500"></textarea>
        </div>
        <button type="button" onclick="enviarComentario()" class="btn btn-primary">Enviar</button>
        </form>
    <%} else {%>
        <div>Você precisa estar logado para comentar. <a href="login.jsp">Clique aqui</a> para fazer login.</div>
    <%}%>
    

    <script>
        
        function enviarComentario() {
            if(<%=isLogged%>){
                let formComentario = document.getElementById("form-comentario")
                let userIdInput = document.createElement('input')
                userIdInput.setAttribute('name', "userId")
                userIdInput.setAttribute('value', <%=isLogged?thisUser.getId():""%>)
                userIdInput.setAttribute('type', 'text')
                userIdInput.setAttribute('hidden', true)

                let postIdInput = document.createElement('input')
                postIdInput.setAttribute('name', "postId")
                postIdInput.setAttribute('value', <%=postId%>)
                postIdInput.setAttribute('type', 'text')
                postIdInput.setAttribute('hidden', true)

                formComentario.appendChild(userIdInput)
                formComentario.appendChild(postIdInput)
                
                formComentario.submit()
                }           
            }
        
            function editarPost(){
                let postCard = document.getElementById('post-card');
                let editForm = document.getElementById('edit-form');
                postCard.setAttribute('hidden', true);
                editForm.removeAttribute('hidden');             
            }

            function alterarPost(){
                let editForm = document.getElementById('edit-form')
                editForm.appendChild(criarElemento('postId', <%=postId%>))

                editForm.submit()

            }

            function deletarPost(){
                let deleteForm = criarPostForm('delete.jsp')
                deleteForm.appendChild(criarElemento('postId',<%=postId%>))
                deleteForm.submit();
            }

            function moderarComentario(commentId, acao){
                let apForm = criarPostForm(acao);
                apForm.appendChild(criarElemento('commentId', commentId))
                apForm.appendChild(criarElemento('postId', <%=postId%>))
                apForm.submit();
            }

            function criarElemento( nome, valor){   
                let newInput = document.createElement('input')
                newInput.setAttribute("type", "text")
                newInput.setAttribute('hidden', true)
                newInput.setAttribute("name", nome)
                newInput.setAttribute("value", valor)
                return newInput
            }
            function criarPostForm(acao){
                let thisForm = document.createElement('form')
                thisForm.setAttribute("action", acao)
                thisForm.setAttribute("method", "POST")
                thisForm.setAttribute("hidden", true)
                document.body.appendChild(thisForm)
                return thisForm
            }
    </script>

</div>