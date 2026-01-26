<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Détail Facture</title>
</head>
<body>

<c:if test="${not empty message}">
    <div style="padding:10px; background:#e6ffed; border:1px solid #b7f5c8; margin-bottom:16px;">${message}</div>
</c:if>
<c:if test="${not empty error}">
    <div style="padding:10px; background:#ffecec; border:1px solid #f5b7b1; margin-bottom:16px; color:#a40000;">${error}</div>
</c:if>

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
</table>

<hr>

<h3>Totaux</h3>
<p><strong>Total HT :</strong> ${facture.montantTotalHt}</p>
<p><strong>Total TVA :</strong> ${facture.montantTva}</p>
<p><strong>Total TTC :</strong> ${facture.montantTtc}</p>
<p><strong>Montant payé :</strong> ${montantPaye}</p>
<p><strong>Reste à payer :</strong> ${resteAPayer}</p>

<hr>

<h3>Enregistrer un encaissement</h3>
<form action="${pageContext.request.contextPath}/vente/factures/${facture.idFacture}/encaisser" method="post">
    <label for="montant">Montant</label>
    <input type="number" step="0.01" min="0" name="montant" id="montant" required>
    <br>
    <label for="modeReglement">Mode de règlement</label>
    <select name="modeReglement" id="modeReglement" required>
        <option value="VIREMENT">Virement</option>
        <option value="CHEQUE">Chèque</option>
        <option value="CARTE">Carte</option>
        <option value="ESPECES">Espèces</option>
        <option value="PRELEVEMENT">Prélèvement</option>
    </select>
    <br>
    <label for="referencePaiement">Référence (optionnel)</label>
    <input type="text" name="referencePaiement" id="referencePaiement" placeholder="N° de chèque, ref virement...">
    <br><br>
    <button type="submit">Enregistrer le paiement</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/vente/factures">⬅ Retour</a>

</body>
</html>
