<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Liste Factures</title>
</head>
<body>

<h2>💰 Factures à encaisser</h2>

<table border="1" cellpadding="5">
    <tr>
        <th>Numéro</th>
        <th>Client</th>
        <th>Commande</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Total TTC</th>
        <th>Montant payé</th>
        <th>Solde restant</th>
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
            <td>${f.montantPaye}</td>
            <td>${f.soldeRestant}</td>
            <td>
                <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}">
                    👁 Voir
                </a>
            </td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>


</body>
</html>
