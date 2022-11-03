<body>
    <%@ include file="header.jsp" %>
    <div id="main-container" class="container">
        <div id="home">
            <%@ include file="home.jsp" %>
        </div>
        <div id="login" hidden>
            <%@ include file="login.jsp" %>
        </div>
    </div>

</body>

<script>

    function getUserInfo(){
        let sUserInfo = sessionStorage.getItem("login")
        if(sUserInfo != null){
            return JSON.parse(sUserInfo);
        }
    }

    function irPagina(idPagina){
        let children = document.getElementById("main-container").children;
        for (let i = 0; i < children.length; i++) {
            let pagina = children[i];
            if(pagina.id == idPagina){
                children[i].removeAttribute("hidden")
            }else{
                children[i].setAttribute("hidden", true)
            }
        }
    }
  </script>
</html>