
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.blogjsp.entities.User" %>
<%@page import="com.blogjsp.dao.UserDao" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
</head>

<body>
    
   <form action="login.jsp" method="POST" class="row justify-content-center m-3" style="height: 400px;">
        <div class="col-auto" >
            <input type="email" class="form-control m-2" name="userEmail" id="userEmail" placeholder="user@email.com" required>
            <input type="password" class="form-control m-2" name="password" id="password" placeholder="password" required>
            <div class="d-grid gap-2">
                <button type="button" class="btn btn-link" onclick="alterarModo()" id="link">Não é cadastrado? Clique aqui!</button>
                <button class="btn btn-primary" id="botao">Login</button>
            </div>
            <div id="mensagem" class="text-center m-2 fs-6"></div>
            <input type="checkbox" name="cadastro" id="cadastro" value="true" hidden>
        </div>
    </form>
</body>
<script>
    let cadastro = false;
    function alterarModo(){
        cadastro = !cadastro;
        document.getElementById("cadastro").checked = cadastro;
        document.getElementById("link").innerHTML = cadastro ? "Já é Cadastrado? Clique para o Login." : "Não é cadastrado? Clique aqui!"
        document.getElementById("botao").innerHTML = cadastro ? "Cadastrar" : "Login"
    }
</script>

</html>
<%
    if(request.getMethod() == "POST"){
        String userEmail = request.getParameter("userEmail");
        String password = request.getParameter("password");
        boolean cadastro = Boolean.parseBoolean(request.getParameter("cadastro"));
        
        User user = new User(userEmail, password);

        if(cadastro){
            String res = UserDao.saveUser(user);
    
            out.write("<script>document.getElementById('mensagem').innerHTML = '<p>"+res+"</p>'</script>");   
                    
        } else {
            User loggedUser = UserDao.login(user);

            if(loggedUser != null){
                request.getSession().setAttribute("logUser", loggedUser);
                out.write("<script>sessionStorage.setItem('login', JSON.stringify({userId: '"+loggedUser.getId()+"', userEmail: '"+loggedUser.getUserEmail()+"', isAdmin: '"+loggedUser.isAdmin()+"', logged: true}))</script>");
                out.write("<script>window.location.href='/'</script>");
            } else {
                out.write("<script>sessionStorage.removeItem('login')</script>");
                out.write("<script>document.getElementById('mensagem').innerHTML = '<p>Usuário e/ou senha incorreta.</p>'</script>");
            }
        }
    }
%>