<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>

<% List<Notification> notiList = (List<Notification>) request.getAttribute("notiList"); %>
<% for (Notification noti : notiList) { %>
<li>
    <a href="#" class="dropdown-item notification-item <%= noti.isIsRead() ? "bg-white text-dark" : "bg-light text-dark" %>"
       data-id="<%= noti.getNotificationId() %>">
        <%= noti.getMessage() %><br>
        <small><%= noti.getCreatedAt() %></small>
    </a>
</li>
<% } %>
