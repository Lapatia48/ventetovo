<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion de Stock - Tableau de Bord</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            color: #333;
            font-size: 28px;
        }
        .menu {
            display: flex;
            gap: 10px;
        }
        .menu a {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        .menu a:hover {
            background: #764ba2;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
        }
        .alert-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .alert-section h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 20px;
        }
        .alert-item {
            padding: 15px;
            border-left: 4px solid;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .alert-danger {
            border-color: #dc3545;
            background: #f8d7da;
        }
        .alert-warning {
            border-color: #ffc107;
            background: #fff3cd;
        }
        .table {
            width: 100%;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Gestion de Stock - Tableau de Bord</h1>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/gestionstock/stocks">Stocks</a>
                <a href="${pageContext.request.contextPath}/gestionstock/mouvements">Mouvements</a>
                <a href="${pageContext.request.contextPath}/gestionstock/lots">Lots</a>
                <a href="${pageContext.request.contextPath}/gestionstock/configuration">Configuration</a>
                <a href="${pageContext.request.contextPath}/gestionstock/rapports/chiffre-affaires">Rapports</a>
                <a href="${pageContext.request.contextPath}/">Accueil</a>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Valeur Stock Total</h3>
                <div class="stat-value"><fmt:formatNumber value="${valeurStockTotal}" pattern="#,##0.00" /> Ar</div>
            </div>
            <div class="stat-card">
                <h3>Nombre d'Articles</h3>
                <div class="stat-value">${nombreArticles}</div>
            </div>
            <div class="stat-card">
                <h3>Alertes Stock Faible</h3>
                <div class="stat-value" style="color: #dc3545;">${stocksFaibles.size()}</div>
            </div>
            <div class="stat-card">
                <h3>Alertes Péremption</h3>
                <div class="stat-value" style="color: #ffc107;">${lotsProchesPeremption.size()}</div>
            </div>
        </div>

        <!-- Alertes Stock Faible -->
        <c:if test="${not empty stocksFaibles}">
            <div class="alert-section">
                <h2>⚠️ Alertes Stock Faible</h2>
                <c:forEach items="${stocksFaibles}" var="stock">
                    <div class="alert-item alert-danger">
                        <strong>Article #${stock.idArticle}</strong> - 
                        Stock: ${stock.quantiteDisponible} / Minimum: ${stock.stockMinimum}
                        <a href="${pageContext.request.contextPath}/gestionstock/stocks/${stock.idStock}" 
                           style="float: right; color: #dc3545;">Détails →</a>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Alertes Péremption -->
        <c:if test="${not empty lotsProchesPeremption}">
            <div class="alert-section">
                <h2>⏰ Alertes Péremption (30 jours)</h2>
                <c:forEach items="${lotsProchesPeremption}" var="lot">
                    <div class="alert-item alert-warning">
                        <strong>${lot.numeroLot}</strong> - Article #${lot.idArticle} - 
                        Péremption: <fmt:formatDate value="${lot.peremptionAsDate}" pattern="dd/MM/yyyy" />
                        - Quantité: ${lot.quantiteRestante}
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Mouvements du jour -->
        <div class="alert-section">
            <h2>📦 Mouvements du jour (${mouvementsJour.size()})</h2>
            <c:if test="${not empty mouvementsJour}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Article</th>
                            <th>Quantité</th>
                            <th>Coût Total</th>
                            <th>Référence</th>
                            <th>Heure</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${mouvementsJour}" var="mouvement">
                            <tr>
                                <td>${mouvement.numeroMouvement}</td>
                                <td>#${mouvement.idArticle}</td>
                                <td>${mouvement.quantite}</td>
                                <td><fmt:formatNumber value="${mouvement.coutTotal}" pattern="#,##0.00" /> Ar</td>
                                <td>${mouvement.referenceDocument}</td>
                                <td><fmt:formatDate value="${mouvement.dateMouvementAsDate}" pattern="HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty mouvementsJour}">
                <p style="text-align: center; color: #999; padding: 20px;">Aucun mouvement aujourd'hui</p>
            </c:if>
        </div>
    </div>
</body>
</html>
