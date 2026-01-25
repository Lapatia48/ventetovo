<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Factures Validées</title>
</head>
<body>

<h2>📄 Factures Validées</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" width="100%">
    <tr>
        <th>Numéro</th>
        <th>Client</th>
        <th>Commande</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Total TTC</th>
        <th>Montant Payé</th>
        <th>Solde Restant</th>
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
                <form method="post"
                      action="${pageContext.request.contextPath}/vente/factures/envoyer"
                      style="display:inline;">
                    <input type="hidden" name="idFacture" value="${f.idFacture}" />
                    <button type="submit">📤 Envoyer</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/factures">📄 Toutes les Factures</a>
<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>

</body>
</html>