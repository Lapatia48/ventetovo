<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Détail Facture</title>
</head>
<body>

<h2>📄 Facture ${facture.numeroFacture}</h2>

<p><strong>Client :</strong> ${facture.idClient}</p>
<p><strong>Commande :</strong> ${facture.idCommande}</p>
<p><strong>Livraison :</strong> ${facture.idLivraison}</p>
<p><strong>Date :</strong> ${facture.dateFacture}</p>
<p><strong>Statut :</strong> ${facture.statut}</p>

<hr>

<h3>Lignes de facture</h3>

<table border="1" cellpadding="5">
    <tr>
        <th>Article</th>
        <th>Qté</th>
        <th>PU HT</th>
        <th>Remise %</th>
        <th>Montant HT</th>
        <th>TVA</th>
        <th>Total TTC</th>
    </tr>

    <c:forEach items="${lignes}" var="l">
        <tr>
            <td>${l.idArticle}</td>
            <td>${l.quantite}</td>
            <td>${l.prixUnitaireHt}</td>
            <td>${l.remise}</td>
            <td>${l.montantHt}</td>
            <td>${l.montantTva}</td>
            <td>${l.montantTtc}</td>
        </tr>
    </c:forEach>
    <c:if test="${facture.statut == 'ENVOYEE' || facture.statut == 'PARTIELLEMENT_PAYEE'}">
    <form action="${pageContext.request.contextPath}/vente/factures/encaisser"
          method="post">

        <input type="hidden" name="idFacture" value="${facture.idFacture}" />

        Montant :
        <input type="number" name="montant" step="0.01" required />

        Mode :
        <select name="modePaiement">
            <option value="VIREMENT">Virement</option>
            <option value="CHEQUE">Chèque</option>
            <option value="CARTE">Carte</option>
            <option value="ESPECES">Espèces</option>
        </select>

        <button type="submit">💰 Encaisser</button>
    </form>
</c:if>

</table>

<hr>

<h3>Totaux</h3>
<p><strong>Total HT :</strong> ${facture.montantTotalHt}</p>
<p><strong>Total TVA :</strong> ${facture.montantTva}</p>
<p><strong>Total TTC :</strong> ${facture.montantTtc}</p>

<br>
<a href="${pageContext.request.contextPath}/vente/factures">⬅ Retour</a>

</body>
</html>
