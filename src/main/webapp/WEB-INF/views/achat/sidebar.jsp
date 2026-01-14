<%-- sidebar.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* Styles pour la sidebar */
    .sidebar-container {
        width: 250px;
        background-color: #343a40;
        color: white;
        min-height: 100vh;
        padding: 20px 0;
        float: left;
    }
    
    .sidebar-header {
        padding: 0 20px 20px 20px;
        border-bottom: 1px solid #495057;
        margin-bottom: 20px;
    }
    
    .sidebar-header h3 {
        margin: 0;
        color: #f8f9fa;
        font-size: 1.2rem;
    }
    
    .sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .sidebar-menu li {
        padding: 0;
    }
    
    .sidebar-menu a {
        display: block;
        padding: 12px 20px;
        color: #adb5bd;
        text-decoration: none;
        transition: all 0.3s;
    }
    
    .sidebar-menu a:hover {
        background-color: #495057;
        color: white;
        border-left: 4px solid #007bff;
    }
    
    .sidebar-logout {
        margin-top: 30px;
        padding: 0 20px;
    }
    
    .sidebar-logout a {
        display: block;
        padding: 12px 20px;
        background-color: #dc3545;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        text-align: center;
        transition: background-color 0.3s;
    }
    
    .sidebar-logout a:hover {
        background-color: #c82333;
    }
    
    /* Cette classe doit être appliquée au conteneur principal de votre page */
    .main-content {
        margin-left: 250px;
        padding: 20px;
        min-height: 100vh;
        background-color: #f8f9fa;
    }
</style>

<div class="sidebar-container">
    <div class="sidebar-header">
        <h3> Menu Achat</h3>
        <c:if test="${not empty sessionScope.utilisateur}">
            <small style="color: #6c757d;">
                Connecté: ${sessionScope.utilisateur.email}
            </small>
        </c:if>
    </div>
    
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/achat/achat">
                 Articles
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/achat/demandes">
                Demandes
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/achat/proformas">
                Proformas
            </a>
        </li>
    </ul>
    
    <div class="sidebar-logout">
        <a href="${pageContext.request.contextPath}/user/logout">
            🚪 Déconnexion
        </a>
    </div>
</div>