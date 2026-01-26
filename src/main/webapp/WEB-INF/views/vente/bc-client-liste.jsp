<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Bons de Commande Clients</title>
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
        .badge-success { background: #27ae60; color: white; }
        .badge-danger { background: #e74c3c; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Bons de Commande Clients</h1>

        <table>
            <thead>
                <tr>
                    <th>Numéro BC</th>
                    <th>Client</th>
                    <th>Article</th>
                    <th>Quantité</th>
                    <th>Montant Total</th>
                    <th>Date</th>
                    <th>Stock Vérifié</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="bc" items="${bonsCommande}">
                    <tr>
                        <td>${bc.numeroBcClient}</td>
                        <td>${bc.idClient}</td>
                        <td>${bc.idArticle}</td>
                        <td>${bc.quantite}</td>
                        <td>${bc.montantTotal} Ar</td>
                        <td>${bc.dateCommande}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bc.stockVerifie}">
                                    <c:choose>
                                        <c:when test="${bc.stockSuffisant}">
                                            <span class="badge badge-success">OUI (Suffisant)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">OUI (Insuffisant)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">Non vérifié</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${bc.statut == 'EN_COURS'}">
                                    <span class="badge badge-warning">EN COURS</span>
                                </c:when>
                                <c:when test="${bc.statut == 'CONFIRME'}">
                                    <span class="badge badge-success">CONFIRMÉ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">${bc.statut}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vente/bc/detail/${bc.idBonCommandeClient}" class="btn">Détails</a>
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
