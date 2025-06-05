<%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Admin User Management</title>
            <style>
                table {
                    border-collapse: collapse;
                    width: 100%;
                }
                
                th,
                td {
                    border: 1px solid #dddddd;
                    text-align: left;
                    padding: 8px;
                }
                
                th {
                    background-color: #f2f2f2;
                }
            </style>
        </head>

        <body>
            <a href="menu.jsp" style="display:inline-block;margin-bottom:16px;padding:8px 16px;background:#007bff;color:#fff;text-decoration:none;border-radius:4px;">&larr; Quay lại menu</a>
            <h1>Admin User Management</h1>
            <c:if test="${requestScope.error != null}">
                <p style="color: red;">${requestScope.error}</p>
            </c:if>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Active</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${requestScope.userList}">
                        <tr>
                            <td>
                                <c:out value="${user.userId}" />
                            </td>
                            <td>
                                <c:out value="${user.username}" />
                            </td>
                            <td>
                                <c:out value="${user.fullName}" />
                            </td>
                            <td>
                                <c:out value="${user.email}" />
                            </td>
                            <td>
                                <c:out value="${user.phone}" />
                            </td>
                            <td>
                                <c:out value="${user.role}" />
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.isActive}"><span style="color:green;">Active</span></c:when>
                                    <c:otherwise><span style="color:red;">Blocked</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form method="post" action="user-management" style="display:inline;">
                                    <input type="hidden" name="userId" value="${user.userId}" />
                                    <c:choose>
                                        <c:when test="${user.isActive}">
                                            <button type="submit" name="action" value="block">Block</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" name="action" value="unblock">Unblock</button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                                <form method="post" action="user-management" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                    <input type="hidden" name="userId" value="${user.userId}" />
                                    <button type="submit" name="action" value="delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </body>

        </html>