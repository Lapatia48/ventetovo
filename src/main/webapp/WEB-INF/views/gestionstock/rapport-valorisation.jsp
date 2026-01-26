<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rapport de Valorisation du Stock</title>
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
            margin-bottom: 20px;
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
        .btn {
            padding: 8px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            display: inline-block;
        }
        .btn:hover {
            background: #764ba2;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-fifo {
            background: #28a745;
            color: white;
        }
        .badge-cmup {
            background: #17a2b8;
            color: white;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .summary-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .summary-card .value {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Rapport de Valorisation du Stock</h1>
        </div>

        <!-- Valeur totale -->
        <div class="stat-card">
            <h3 style="text-align: center; color: #666; margin-bottom: 10px;">Valeur Totale du Stock</h3>
            <div class="stat-value"><fmt:formatNumber value="${valeurTotale}" pattern="#,##0.00" /> Ar</div>
        </div>

        <!-- Résumé par méthode -->
        <div class="summary-grid">
            <c:forEach items="${valeurParMethode}" var="entry">
                <div class="summary-card">
                    <h3>Méthode ${entry.key}</h3>
                    <div class="value"><fmt:formatNumber value="${entry.value}" pattern="#,##0.00" /> Ar</div>
                    <p style="color: #999; font-size: 12px; margin-top: 5px;">
                        ${stocksParMethode[entry.key].size()} articles
                    </p>
                </div>
            </c:forEach>
        </div>

        <!-- Détail par méthode -->
        <c:forEach items="${stocksParMethode}" var="entry">
            <c:set var="methode" value="${entry.key}" />
            <c:set var="stocks" value="${entry.value}" />
            
            <div class="content">
                <h2 style="margin-bottom: 20px;">
                    <c:choose>
                        <c:when test="${methode == 'FIFO'}">
                            <span class="badge badge-fifo">FIFO</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-cmup">CMUP</span>
                        </c:otherwise>
                    </c:choose>
                    Stocks valorisés en ${methode}
                </h2>
                
                <table class="table">
                    <thead>
                        <tr>
                            <th>Article</th>
                            <th>Quantité</th>
                            <th>Coût Moyen Unitaire</th>
                            <th>Valeur Stock</th>
                            <th>% du Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${stocks}" var="stock">
                            <c:set var="article" value="${articlesMap[stock.idArticle]}" />
                            <c:set var="pourcentage" value="${(stock.valeurStock / valeurTotale) * 100}" />
                            <tr>
                                <td><strong>${article != null ? article.designation : 'Article #' + stock.idArticle}</strong></td>
                                <td>${stock.quantiteDisponible}</td>
                                <td><fmt:formatNumber value="${stock.coutMoyenUnitaire}" pattern="#,##0.00" /> Ar</td>
                                <td><fmt:formatNumber value="${stock.valeurStock}" pattern="#,##0.00" /> Ar</td>
                                <td><fmt:formatNumber value="${pourcentage}" pattern="#0.00" />%</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot style="background: #f8f9fa; font-weight: bold;">
                        <tr>
                            <td colspan="3" style="text-align: right;">Sous-total ${methode}:</td>
                            <td colspan="2">
                                <fmt:formatNumber value="${valeurParMethode[methode]}" pattern="#,##0.00" /> Ar
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </c:forEach>

        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/gestionstock/rapports/chiffre-affaires" class="btn">
                Rapport CA
            </a>
            <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">
                ← Retour au Tableau de Bord
            </a>
        </div>

        <!-- Légende -->
        <div class="content" style="margin-top: 20px;">
            <h3 style="margin-bottom: 15px;">📖 Explications</h3>
            <p><strong>FIFO (First In First Out):</strong> Valorisation basée sur le coût des lots les plus anciens. Les sorties sont valorisées au coût des premiers lots entrés.</p>
            <p style="margin-top: 10px;"><strong>CMUP (Coût Moyen Pondéré):</strong> Valorisation basée sur le coût moyen pondéré de tous les achats. Le coût est recalculé à chaque entrée.</p>
            <p style="margin-top: 10px;"><strong>Valeur Stock:</strong> Quantité disponible × Coût moyen unitaire</p>
        </div>
    </div>
</body>
</html>
