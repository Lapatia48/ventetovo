<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Commandes à livrer</title>
</head>
<body>

<h2>📦 Commandes à livrer</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" cellpadding="5">
    <tr>
        <th>Commande</th>
        <th>Client</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${commandes}" var="cmd">
        <tr>
            <td>${empty cmd.numeroCommande ? 'N/A' : cmd.numeroCommande}</td>
            <td>${cmd.idClient}</td>
            <td>${cmd.dateCommande}</td>
            <td>${empty cmd.statut ? 'N/A' : cmd.statut}</td>
            <td>
                <a href="${pageContext.request.contextPath}/vente/livraisons/nouveau?idCommande=${cmd.idCommande}">
                    🚚 Préparer livraison
                </a>
            </td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>

</body>
</html>
