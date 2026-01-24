<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmation Commande</title>
</head>
<body>

<h2>Confirmation de la commande</h2>

<p><strong>Numéro devis :</strong> ${empty devis.numeroDevis ? 'N/A' : devis.numeroDevis}</p>
<p><strong>Client :</strong> ${devis.idClient}</p>
<p><strong>Montant TTC :</strong> ${devis.montantTtc}</p>

<form action="${pageContext.request.contextPath}/vente/commandes/creer" method="post">

    <input type="hidden" name="idDevis" value="${devis.idDevis}" />

    <label>Date de livraison souhaitée :</label><br>
    <input type="date" name="dateLivraison" required /><br><br>

    <button type="submit">Confirmer la commande</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/vente/commandes/a-valider">← Retour validation</a>


</body>
</html>
