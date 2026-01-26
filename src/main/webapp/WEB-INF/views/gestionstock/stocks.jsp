<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion de Stock - Stocks</title>
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
            margin-top: 15px;
        }
        .filters a {
            padding: 8px 15px;
            background: #f8f9fa;
            color: #333;
            text-decoration: none;
            border-radius: 5px;
            border: 2px solid transparent;
            transition: 0.3s;
        }
        .filters a.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        .filters a:hover {
            border-color: #667eea;
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
        .badge-success {
            background: #28a745;
            color: white;
        }
        .badge-warning {
            background: #ffc107;
            color: #333;
        }
        .badge-danger {
            background: #dc3545;
            color: white;
        }
        .btn {
            padding: 8px 15px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            transition: 0.3s;
        }
        .btn:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📦 Liste des Stocks</h1>
            <div class="filters">
                <a href="${pageContext.request.contextPath}/gestionstock/stocks" 
                   class="${empty filtreActif ? 'active' : ''}">Tous</a>
                <a href="${pageContext.request.contextPath}/gestionstock/stocks?filtre=faible"
                   class="${filtreActif == 'faible' ? 'active' : ''}">Stock Faible</a>
                <a href="${pageContext.request.contextPath}/gestionstock/stocks?filtre=critique"
                   class="${filtreActif == 'critique' ? 'active' : ''}">Stock Critique</a>
            </div>
        </div>

        <div class="content">
            <table class="table">
                <thead>
                    <tr>
                        <th>Article</th>
                        <th>Qté Disponible</th>
                        <th>Qté Réservée</th>
                        <th>Stock Min</th>
                        <th>CMUP</th>
                        <th>Valeur</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${stocks}" var="stock">
                        <c:set var="article" value="${articlesMap[stock.idArticle]}" />
                        <tr>
                            <td>
                                <strong>${article != null ? article.designation : 'Article #' + stock.idArticle}</strong>
                            </td>
                            <td>${stock.quantiteDisponible}</td>
                            <td>${stock.quantiteReservee}</td>
                            <td>${stock.stockMinimum}</td>
                            <td><fmt:formatNumber value="${stock.coutMoyenUnitaire}" pattern="#,##0.00" /> Ar</td>
                            <td><fmt:formatNumber value="${stock.valeurStock}" pattern="#,##0.00" /> Ar</td>
                            <td>
                                <c:choose>
                                    <c:when test="${stock.quantiteDisponible == 0}">
                                        <span class="badge badge-danger">Rupture</span>
                                    </c:when>
                                    <c:when test="${stock.quantiteDisponible <= stock.stockMinimum}">
                                        <span class="badge badge-warning">Faible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-success">OK</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/gestionstock/stocks/${stock.idStock}" 
                                   class="btn">Détails</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty stocks}">
                <p style="text-align: center; color: #999; padding: 40px;">Aucun stock trouvé</p>
            </c:if>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">← Retour au Tableau de Bord</a>
            </div>
        </div>
    </div>
</body>
</html>
