<%-- 
    Document   : index
    Created on : May 22, 2025, 12:10:03 PM
    Author     : X1 Carbon Gen6
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Redirect to Login</title>
</head>
<body>
    <% 
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    %>

</body>
</html>