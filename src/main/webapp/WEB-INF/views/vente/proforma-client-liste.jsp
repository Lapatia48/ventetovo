<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Proformas Clients</title>
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
        .badge-danger { background: #e74c3c; color: white; }
        .badge-secondary { background: #95a5a6; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Proformas Clients</h1>

        <div class="filter-bar">
            <form action="${pageContext.request.contextPath}/vente/proforma/list" method="get">
                <label for="statut">Filtrer par statut:</label>
                <select id="statut" name="statut">
                    <option value="">Tous</option>
                    <option value="EN_ATTENTE" ${statutFiltre == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                    <option value="ACCEPTE" ${statutFiltre == 'ACCEPTE' ? 'selected' : ''}>Accepté</option>
                    <option value="REFUSE" ${statutFiltre == 'REFUSE' ? 'selected' : ''}>Refusé</option>
                    <option value="EXPIRE" ${statutFiltre == 'EXPIRE' ? 'selected' : ''}>Expiré</option>
                </select>
                <button type="submit">Filtrer</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Numéro</th>
                    <th>Client</th>
                    <th>Article</th>
                    <th>Quantité</th>
                    <th>Montant Total</th>
                    <th>Date</th>
                    <th>Validité</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="proforma" items="${proformas}">
                    <tr>
                        <td>${proforma.numeroProforma}</td>
                        <td>${proforma.idClient}</td>
                        <td>${proforma.idArticle}</td>
                        <td>${proforma.quantite}</td>
                        <td>${proforma.montantTotal} Ar</td>
                        <td>${proforma.dateProforma}</td>
                        <td>${proforma.dateValidite}</td>
                        <td>
                            <c:choose>
                                <c:when test="${proforma.statut == 'EN_ATTENTE'}">
                                    <span class="badge badge-warning">EN ATTENTE</span>
                                </c:when>
                                <c:when test="${proforma.statut == 'ACCEPTE'}">
                                    <span class="badge badge-success">ACCEPTÉ</span>
                                </c:when>
                                <c:when test="${proforma.statut == 'REFUSE'}">
                                    <span class="badge badge-danger">REFUSÉ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">${proforma.statut}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vente/proforma/detail/${proforma.idProformaClient}" class="btn">Détails</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/vente/vente" class="btn">Retour aux articles</a>
        </div>
    </div>
</body>
</html>
