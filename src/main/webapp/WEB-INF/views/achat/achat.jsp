<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des articles</title>
</head>
<body>
    <p><a href="${pageContext.request.contextPath}/achat/demandes">Voir toutes les demandes</a></p>
    <p><a href="${pageContext.request.contextPath}/bc/list">Liste des bons de commande</a></p>
    <p><a href="${pageContext.request.contextPath}/factureFournisseur/list">Liste des factures fournisseurs</a></p>
    <p><a href="${pageContext.request.contextPath}/bonLivraison/list">Bons de livraison</a></p>
    


    <h2>Liste des articles</h2>
    
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Désignation</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty articles}">
                    <c:forEach var="article" items="${articles}">
                        <tr>
                            <td>${article.idArticle}</td>
                            <td>${article.code}</td>
                            <td>${article.designation}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/achat/quantite?idArticle=${article.idArticle}">
                                    Demande d'achat
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4" style="color: red; text-align: center;">
                            Aucun article trouvé!
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</body>
</html>