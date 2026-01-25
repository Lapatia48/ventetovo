<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>💰 Factures à encaisser</title>
</head>
<body>

<h2>💰 Factures à encaisser</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" cellpadding="5">
    <tr>
        <th>Numéro</th>
        <th>Client</th>
        <th>Commande</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Total TTC</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${factures}" var="f">
        <tr>
            <td>${f.numeroFacture}</td>
            <td>${f.idClient}</td>
            <td>${f.idCommande}</td>
            <td>${f.dateFacture}</td>
            <td>${f.statut}</td>
            <td>${f.montantTtc}</td>
            <td>
                <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}">
                    👁 Voir / Encaisser
                </a>
            </td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>

</body>
</html>
