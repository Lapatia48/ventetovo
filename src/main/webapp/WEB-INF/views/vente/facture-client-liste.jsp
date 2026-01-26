<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Factures Clients</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        h1 { color: #333; margin-bottom: 20px; }
        .filter-bar { background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .filter-bar select { padding: 8px; border-radius: 4px; border: 1px solid #ddd; }
        .filter-bar button { padding: 8px 20px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; margin-left: 10px; }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f8f9fa; }
        .btn { display: inline-block; padding: 8px 15px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background: #2980b9; }
        .badge { display: inline-block; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-warning { background: #f39c12; color: white; }
        .badge-success { background: #27ae60; color: white; }
        .badge-info { background: #3498db; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Factures Clients</h1>

        <div class="filter-bar">
            <form action="${pageContext.request.contextPath}/vente/facture/list" method="get">
                <label for="statut">Filtrer par statut:</label>
                <select id="statut" name="statut">
                    <option value="">Tous</option>
                    <option value="NON_PAYE" ${statutFiltre == 'NON_PAYE' ? 'selected' : ''}>Non payé</option>
                    <option value="PARTIEL" ${statutFiltre == 'PARTIEL' ? 'selected' : ''}>Payé partiellement</option>
                    <option value="PAYE" ${statutFiltre == 'PAYE' ? 'selected' : ''}>Payé</option>
                </select>
                <button type="submit">Filtrer</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Numéro Facture</th>
                    <th>Client</th>
                    <th>Montant Total</th>
                    <th>Montant Payé</th>
                    <th>Montant Restant</th>
                    <th>Date</th>
                    <th>Échéance</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="facture" items="${factures}">
                    <tr>
                        <td>${facture.numeroFactureClient}</td>
                        <td>${facture.idClient}</td>
                        <td>${facture.montantTotal} Ar</td>
                        <td>${facture.montantPaye} Ar</td>
                        <td>${facture.montantTotal - facture.montantPaye} Ar</td>
                        <td>${facture.dateFacture}</td>
                        <td>${facture.dateEcheance}</td>
                        <td>
                            <c:choose>
                                <c:when test="${facture.statutPaiement == 'NON_PAYE'}">
                                    <span class="badge badge-warning">NON PAYÉ</span>
                                </c:when>
                                <c:when test="${facture.statutPaiement == 'PARTIEL'}">
                                    <span class="badge badge-info">PARTIEL</span>
                                </c:when>
                                <c:when test="${facture.statutPaiement == 'PAYE'}">
                                    <span class="badge badge-success">PAYÉ</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vente/facture/detail/${facture.idFactureClient}" class="btn">Détails</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/vente/vente" class="btn">Retour</a>
        </div>
    </div>
</body>
</html>
