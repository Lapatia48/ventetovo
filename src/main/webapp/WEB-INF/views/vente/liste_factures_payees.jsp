<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Factures payées</title>
</head>
<body>

<h2>💰 Factures payées</h2>


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
            <c:choose>
                <c:when test="${f.statut == 'PAYEE'}">
                     Payée
                </c:when>
                <c:when test="${f.statut == 'PARTIELLEMENT_PAYEE'}">
                     Partiellement payée
                </c:when>
                <c:otherwise>
                    ${f.statut}
                </c:otherwise>
            </c:choose>
        </td>

            <td>
                <a href="${pageContext.request.contextPath}/vente/factures/${f.idFacture}">
                    👁 Voir
                </a>
                <form method="post"
                      action="${pageContext.request.contextPath}/vente/factures/envoyer"
                      style="display:inline;">
                    <input type="hidden" name="idFacture" value="${f.idFacture}" />
                    <button type="submit"> Envoyer</button>
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