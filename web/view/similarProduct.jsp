<%-- 
    Document   : similarProduct
    Created on : Jun 3, 2025, 9:13:38 PM
    Author     : X1 carbon Gen6
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sản phẩm tương tự</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/similar.css">
    </head>
    <body>
        <h1>Sản phẩm tương tự</h1>
        <div class="similar-container">
            <c:forEach var="p" items="${similarProducts}">
                <div class="similar-item">
                    <img src="${p.imageUrl}" alt="${p.name}">
                    <h4>${p.name}</h4>
                    <p class="description">${p.description}</p>
                    <p><fmt:formatNumber value="${p.price}" type="number"/> VND</p>
                </div>
            </c:forEach>
        </div>
        <br/>
        <a href="${pageContext.request.contextPath}/view/cart.jsp" class="back-button">
            Quay lại Giỏ hàng
        </a>
    </body>
</html>
