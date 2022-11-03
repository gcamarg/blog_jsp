<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <title>Blog</title>
    
</head>


<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container-fluid">
      <a class="navbar-brand" href="login.jsp">Login</a>
      <div>
        <a class="navbar-brand" href="novoPost.jsp">Novo</a>
        <a class="navbar-brand" href="/">Home</a>
      </div>
    </div>
  </nav>

  <script>
    function getUserInfo(){
        let sUserInfo = sessionStorage.getItem("login")
        if(sUserInfo != null){
            return JSON.parse(sUserInfo);
        }
        return null;
    }
    function isUserAdmin() {
        let thisUserInfo = getUserInfo();
        if(thisUserInfo != null){
            return thisUserInfo.isAdmin;
        }
    }
  </script>