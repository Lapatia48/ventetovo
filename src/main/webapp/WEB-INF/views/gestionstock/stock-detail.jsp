<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Détail Stock - ${article.designation}</title>
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
            margin-bottom: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .info-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }
        .info-value {
            font-size: 28px;
            font-weight: bold;
            color: #667eea;
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
        .badge-actif {
            background: #28a745;
            color: white;
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
        .filters {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-bottom: 20px;
        }
        .filters input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📦 ${article.designation}</h1>
            <p style="color: #666;">Code: ${article.codeArticle}</p>
        </div>

        <!-- Indicateurs clés -->
        <div class="info-grid">
            <div class="info-card">
                <h3>Quantité Disponible</h3>
                <div class="info-value">${stock.quantiteDisponible}</div>
            </div>
            <div class="info-card">
                <h3>Quantité Réservée</h3>
                <div class="info-value">${stock.quantiteReservee}</div>
            </div>
            <div class="info-card">
                <h3>Stock Minimum</h3>
                <div class="info-value">${stock.stockMinimum}</div>
            </div>
            <div class="info-card">
                <h3>CMUP</h3>
                <div class="info-value"><fmt:formatNumber value="${stock.coutMoyenUnitaire}" pattern="#,##0" /> Ar</div>
            </div>
            <div class="info-card">
                <h3>Valeur Stock</h3>
                <div class="info-value"><fmt:formatNumber value="${stock.valeurStock}" pattern="#,##0" /> Ar</div>
            </div>
        </div>

        <!-- Configuration -->
        <c:if test="${config != null}">
            <div class="content">
                <h2 style="margin-bottom: 15px;">⚙️ Configuration</h2>
                <p><strong>Méthode de Valorisation:</strong> ${config.methodeValorisation}</p>
                <p><strong>Gestion par Lot:</strong> ${config.gestionLot ? 'Oui' : 'Non'}</p>
                <c:if test="${config.typePeremption != null}">
                    <p><strong>Type Péremption:</strong> ${config.typePeremption}</p>
                    <p><strong>Délai Alerte:</strong> ${config.delaiAlertePeremption} jours</p>
                </c:if>
            </div>
        </c:if>

        <!-- Lots actifs -->
        <c:if test="${not empty lots}">
            <div class="content">
                <h2 style="margin-bottom: 15px;">📦 Lots Actifs</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Numéro Lot</th>
                            <th>Qté Restante</th>
                            <th>Coût Unitaire</th>
                            <th>Date Fabrication</th>
                            <th>Péremption</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${lots}" var="lot">
                            <tr>
                                <td><strong>${lot.numeroLot}</strong></td>
                                <td>${lot.quantiteRestante}</td>
                                <td><fmt:formatNumber value="${lot.coutUnitaire}" pattern="#,##0.00" /> Ar</td>
                                <td><fmt:formatDate value="${lot.dateFabricationAsDate}" pattern="dd/MM/yyyy" /></td>
                                <td>
                                    <c:if test="${lot.dlc != null}">
                                        DLC: <fmt:formatDate value="${lot.dlcAsDate}" pattern="dd/MM/yyyy" />
                                    </c:if>
                                    <c:if test="${lot.dluo != null}">
                                        DLUO: <fmt:formatDate value="${lot.dluoAsDate}" pattern="dd/MM/yyyy" />
                                    </c:if>
                                </td>
                                <td><span class="badge badge-actif">${lot.statut}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <!-- Historique des mouvements -->
        <div class="content">
            <h2 style="margin-bottom: 15px;">📋 Historique des Mouvements</h2>
            
            <!-- Filtres de date -->
            <form method="get" action="${pageContext.request.contextPath}/gestionstock/stocks/${stock.idStock}" class="filters">
                <label>Du:</label>
                <input type="date" name="dateDebut" value="${dateDebut}" required />
                
                <label>Au:</label>
                <input type="date" name="dateFin" value="${dateFin}" required />
                
                <button type="submit" class="btn">Filtrer</button>
            </form>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Quantité</th>
                        <th>Coût Unitaire</th>
                        <th>Coût Total</th>
                        <th>Référence</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${mouvements}" var="mouvement">
                        <tr>
                            <td><fmt:formatDate value="${mouvement.dateMouvementAsDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${mouvement.idTypeMouvement <= 4}">
                                        <span class="badge badge-entree">Entrée</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-sortie">Sortie</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${mouvement.quantite}</td>
                            <td><fmt:formatNumber value="${mouvement.coutUnitaire}" pattern="#,##0.00" /> Ar</td>
                            <td><fmt:formatNumber value="${mouvement.coutTotal}" pattern="#,##0.00" /> Ar</td>
                            <td>${mouvement.referenceDocument}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty mouvements}">
                <p style="text-align: center; color: #999; padding: 40px;">Aucun mouvement sur la période sélectionnée</p>
            </c:if>
        </div>

        <div style="text-align: center;">
            <a href="${pageContext.request.contextPath}/gestionstock/stocks" class="btn">← Retour à la Liste</a>
            <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">Tableau de Bord</a>
        </div>
    </div>
</body>
</html>
