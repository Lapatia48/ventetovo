<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Toutes les demandes</title>
</head>
<body>
    <h2>Toutes les demandes d'achat</h2>
    
    <c:forEach var="demande" items="${demandes}">
        <c:set var="proformas" value="${demande.value}" />
        <c:if test="${not empty proformas}">
            <div style="border: 1px solid #ccc; padding: 15px; margin: 10px 0;">
                <h3>Demande: ${proformas[0].tokenDemande}</h3>
                <p><strong>Article:</strong> 
                    <c:if test="${not empty proformas[0].article}">
                        ${proformas[0].article.code} - ${proformas[0].article.designation}
                    </c:if>
                </p>
                <p><strong>Quantité:</strong> ${proformas[0].quantite}</p>
                <p><strong>Nombre de proformas:</strong> ${proformas.size()}</p>
                
                <a href="${pageContext.request.contextPath}/achat/proformas?token=${proformas[0].tokenDemande}">
                    Voir les proformas
                </a>
            </div>
        </c:if>
    </c:forEach>
    
    <br>
    <a href="${pageContext.request.contextPath}/achat/achat">Nouvelle demande</a>
</body>
</html>