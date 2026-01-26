<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rapport Chiffre d'Affaires</title>
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
        }
        .filters input {
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
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .stat-value {
            font-size: 48px;
            font-weight: bold;
            color: #667eea;
            text-align: center;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>💰 Rapport Chiffre d'Affaires par Article</h1>
            <form method="get" action="${pageContext.request.contextPath}/gestionstock/rapports/chiffre-affaires">
                <div class="filters">
                    <label>Du:</label>
                    <input type="date" name="dateDebut" value="${dateDebut}" required />
                    
                    <label>Au:</label>
                    <input type="date" name="dateFin" value="${dateFin}" required />
                    
                    <button type="submit" class="btn">Filtrer</button>
                </div>
            </form>
        </div>

        <!-- CA Total -->
        <div class="stat-card">
            <h3 style="text-align: center; color: #666; margin-bottom: 10px;">Chiffre d'Affaires Total</h3>
            <div class="stat-value"><fmt:formatNumber value="${caTotal}" pattern="#,##0.00" /> Ar</div>
        </div>

        <!-- Détail par article -->
        <div class="content">
            <h2 style="margin-bottom: 20px;">Détail par Article</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Article</th>
                        <th>Quantité Vendue</th>
                        <th>Chiffre d'Affaires</th>
                        <th>% du CA Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${caParArticle}" var="entry">
                        <c:set var="idArticle" value="${entry.key}" />
                        <c:set var="ca" value="${entry.value}" />
                        <c:set var="article" value="${articlesMap[idArticle]}" />
                        <c:set var="quantite" value="${quantitesParArticle[idArticle]}" />
                        <c:set var="pourcentage" value="${(ca / caTotal) * 100}" />
                        <tr>
                            <td><strong>${article != null ? article.designation : 'Article #' + idArticle}</strong></td>
                            <td>${quantite}</td>
                            <td><fmt:formatNumber value="${ca}" pattern="#,##0.00" /> Ar</td>
                            <td><fmt:formatNumber value="${pourcentage}" pattern="#0.00" />%</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty caParArticle}">
                <p style="text-align: center; color: #999; padding: 40px;">Aucune vente sur la période sélectionnée</p>
            </c:if>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="${pageContext.request.contextPath}/gestionstock/rapports/valorisation" class="btn">
                    Rapport Valorisation
                </a>
                <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">
                    ← Retour au Tableau de Bord
                </a>
            </div>
        </div>
    </div>
</body>
</html>
