

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Search</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .error {
                color: red;
            }
        </style>
    </head>
    <body>
        <h2>Search Products</h2>
        <a href="logout">Logout</a>
        <form action="search" method="get">
            <input type="text" name="keyword" placeholder="Enter keyword" required>
            <input type="submit" value="Search">
        </form>
        <% if (request.getAttribute("products") != null) { %>
        <h3>Results</h3>
        <table>
            <tr><th>ID</th><th>Name</th><th>Price</th></tr>
                    <% for (Product p : (List<Product>)request.getAttribute("products")) { %>
            <tr><td><%= p.getProductId() %></td><td><%= p.getName() %></td><td><%= p.getPrice() %></td></tr>
            <% } %>
        </table>
        <% } %>
        <p class="error">${error}</p>
    </body>
</html>
