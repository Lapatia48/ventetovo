<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Historique des règlements</title>
</head>
<body>

<h2>💰 Historique des règlements</h2>

<table border="1" cellpadding="5">
    <tr>
        <th>Numéro</th>
        <th>Client</th>
        <th>Date</th>
        <th>Montant</th>
        <th>Mode</th>
        <th>Statut</th>
    </tr>

    <c:forEach items="${reglements}" var="r">
        <tr>
            <td>${r.numeroReglement}</td>
            <td>${r.idClient}</td>
            <td>${r.dateReglement}</td>
            <td>${r.montant}</td>
            <td>${r.modeReglement}</td>
            <td>${r.statut}</td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>

</body>
</html>
