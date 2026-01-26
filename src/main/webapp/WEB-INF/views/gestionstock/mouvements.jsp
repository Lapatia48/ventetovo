<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Historique des Mouvements</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 15px;
        }
        .filters {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 15px;
        }
        .filters input, .filters select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .btn {
            padding: 8px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn:hover {
            background: #764ba2;
        }
        .content {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table thead {
            background: #667eea;
            color: white;
        }
        .table th, .table td {
            padding: 15px;
            text-align: left;
        }
        .table tr:nth-child(even) {
            background: #f8f9fa;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-entree {
            background: #28a745;
            color: white;
        }
        .badge-sortie {
            background: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Historique des Mouvements de Stock</h1>
            <form method="get" action="${pageContext.request.contextPath}/gestionstock/mouvements" class="filters">
                <label>Article:</label>
                <select name="idArticle">
                    <option value="">Tous les articles</option>
                    <c:forEach items="${articles}" var="article">
                        <option value="${article.idArticle}" ${idArticleFiltre == article.idArticle ? 'selected' : ''}>
                            ${article.designation}
                        </option>
                    </c:forEach>
                </select>
                
                <label>Du:</label>
                <input type="date" name="dateDebut" value="${dateDebut}" required />
                
                <label>Au:</label>
                <input type="date" name="dateFin" value="${dateFin}" required />
                
                <button type="submit" class="btn">Filtrer</button>
            </form>
        </div>

        <div class="content">
            <h2 style="margin-bottom: 20px;">Total: ${mouvements.size()} mouvements</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Numéro</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Article</th>
                        <th>Quantité</th>
                        <th>Coût Unitaire</th>
                        <th>Coût Total</th>
                        <th>Référence</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${mouvements}" var="mouvement">
                        <c:set var="article" value="${articlesMap[mouvement.idArticle]}" />
                        <tr>
                            <td><strong>${mouvement.numeroMouvement}</strong></td>
                            <td><fmt:formatDate value="${mouvement.dateMouvementAsDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${mouvement.idTypeMouvement <= 4}">
                                        <span class="badge badge-entree">
                                            <c:choose>
                                                <c:when test="${mouvement.idTypeMouvement == 1}">Réception Fournisseur</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 2}">Retour Client</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 3}">Ajustement +</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 4}">Production</c:when>
                                            </c:choose>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-sortie">
                                            <c:choose>
                                                <c:when test="${mouvement.idTypeMouvement == 5}">Livraison Client</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 6}">Retour Fournisseur</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 7}">Ajustement -</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 8}">Casse/Perte</c:when>
                                                <c:when test="${mouvement.idTypeMouvement == 9}">Utilisation</c:when>
                                            </c:choose>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${article != null ? article.designation : 'Article #' + mouvement.idArticle}</td>
                            <td>${mouvement.quantite}</td>
                            <td><fmt:formatNumber value="${mouvement.coutUnitaire}" pattern="#,##0.00" /> Ar</td>
                            <td><fmt:formatNumber value="${mouvement.coutTotal}" pattern="#,##0.00" /> Ar</td>
                            <td>${mouvement.referenceDocument}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty mouvements}">
                <p style="text-align: center; color: #999; padding: 40px;">Aucun mouvement trouvé pour la période sélectionnée</p>
            </c:if>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">← Retour au Tableau de Bord</a>
            </div>
        </div>
    </div>
</body>
</html>
