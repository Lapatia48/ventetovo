<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Bons de Livraison Clients</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        h1 { color: #333; margin-bottom: 20px; }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f8f9fa; }
        .btn { display: inline-block; padding: 8px 15px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background: #2980b9; }
        .badge { display: inline-block; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-warning { background: #f39c12; color: white; }
        .badge-info { background: #3498db; color: white; }
        .badge-success { background: #27ae60; color: white; }
        .badge-danger { background: #e74c3c; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Bons de Livraison Clients</h1>

        <table>
            <thead>
                <tr>
                    <th>Numéro BL</th>
                    <th>Client</th>
                    <th>Article</th>
                    <th>Quantité</th>
                    <th>Date Livraison</th>
                    <th>Date Prévue</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="bl" items="${bonLivraisons}">
                    <tr>
                        <td>${bl.numeroBlClient}</td>
                        <td>${bl.idClient}</td>
                        <td>${bl.idArticle}</td>
                        <td>${bl.quantiteLivree}</td>
                        <td>${bl.dateLivraison}</td>
                        <td>${bl.dateLivraisonPrevue}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bl.statut == 'EN_PREPARATION'}">
                                    <span class="badge badge-warning">EN PRÉPARATION</span>
                                </c:when>
                                <c:when test="${bl.statut == 'EXPEDIE'}">
                                    <span class="badge badge-info">EXPÉDIÉ</span>
                                </c:when>
                                <c:when test="${bl.statut == 'LIVRE'}">
                                    <span class="badge badge-success">LIVRÉ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">${bl.statut}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vente/bl/detail/${bl.idBonLivraisonClient}" class="btn">Détails</a>
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
