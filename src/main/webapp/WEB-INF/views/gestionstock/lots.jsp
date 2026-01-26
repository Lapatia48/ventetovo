<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Lots</title>
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
        .filters select, .filters a {
            padding: 8px 15px;
            border-radius: 5px;
        }
        .filters select {
            border: 1px solid #ddd;
        }
        .btn {
            padding: 8px 15px;
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
        }
        .alert-item {
            padding: 15px;
            border-left: 4px solid #ffc107;
            margin-bottom: 10px;
            background: #fff3cd;
            border-radius: 5px;
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
        .badge-danger {
            background: #dc3545;
            color: white;
        }
        .badge-warning {
            background: #ffc107;
            color: #333;
        }
        .btn-danger {
            background: #dc3545;
        }
        .btn-danger:hover {
            background: #c82333;
        }
    </style>
    <script>
        function bloquerLot(idLot) {
            const raison = prompt("Raison du blocage:");
            if (raison) {
                const formData = new FormData();
                formData.append('raison', raison);
                
                fetch('${pageContext.request.contextPath}/gestionstock/lots/' + idLot + '/bloquer', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Lot bloqué avec succès!');
                        location.reload();
                    } else {
                        alert('Erreur: ' + data.message);
                    }
                })
                .catch(error => alert('Erreur: ' + error));
            }
        }
        
        function filtrerLots() {
            const idArticle = document.getElementById('articleSelect').value;
            const statut = document.getElementById('statutSelect').value;
            let url = '${pageContext.request.contextPath}/gestionstock/lots?';
            if (idArticle) url += 'idArticle=' + idArticle + '&';
            if (statut) url += 'statut=' + statut;
            window.location.href = url;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📦 Gestion des Lots</h1>
            <form class="filters" onsubmit="event.preventDefault(); filtrerLots();">
                <label>Article:</label>
                <select id="articleSelect">
                    <option value="">Tous les articles</option>
                    <c:forEach items="${articles}" var="article">
                        <option value="${article.idArticle}" ${idArticleFiltre == article.idArticle ? 'selected' : ''}>
                            ${article.designation}
                        </option>
                    </c:forEach>
                </select>
                
                <label>Statut:</label>
                <select id="statutSelect">
                    <option value="">Tous</option>
                    <option value="ACTIF" ${statutFiltre == 'ACTIF' ? 'selected' : ''}>Actif</option>
                    <option value="EPUISE" ${statutFiltre == 'EPUISE' ? 'selected' : ''}>Épuisé</option>
                    <option value="EXPIRE" ${statutFiltre == 'EXPIRE' ? 'selected' : ''}>Expiré</option>
                    <option value="BLOQUE" ${statutFiltre == 'BLOQUE' ? 'selected' : ''}>Bloqué</option>
                </select>
                
                <button type="submit" class="btn">Filtrer</button>
            </form>
        </div>

        <!-- Alertes péremption -->
        <c:if test="${not empty lotsAlertes}">
            <div class="alert-section">
                <h2>⚠️ Alertes Péremption (30 jours)</h2>
                <c:forEach items="${lotsAlertes}" var="lot">
                    <c:set var="article" value="${articlesMap[lot.idArticle]}" />
                    <div class="alert-item">
                        <strong>${lot.numeroLot}</strong> - 
                        ${article != null ? article.designation : 'Article #' + lot.idArticle} - 
                        Péremption: <fmt:formatDate value="${lot.peremptionAsDate}" pattern="dd/MM/yyyy" />
                        - Quantité: ${lot.quantiteRestante}
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Liste des lots -->
        <div class="content">
            <table class="table">
                <thead>
                    <tr>
                        <th>Numéro Lot</th>
                        <th>Article</th>
                        <th>Qté Initiale</th>
                        <th>Qté Restante</th>
                        <th>Coût Unitaire</th>
                        <th>Date Fabrication</th>
                        <th>DLC/DLUO</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${lots}" var="lot">
                        <c:set var="article" value="${articlesMap[lot.idArticle]}" />
                        <tr>
                            <td><strong>${lot.numeroLot}</strong></td>
                            <td>${article != null ? article.designation : 'Article #' + lot.idArticle}</td>
                            <td>${lot.quantiteInitiale}</td>
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
                                <c:if test="${lot.dlc == null && lot.dluo == null}">
                                    -
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${lot.statut == 'ACTIF'}">
                                        <span class="badge badge-success">Actif</span>
                                    </c:when>
                                    <c:when test="${lot.statut == 'EPUISE'}">
                                        <span class="badge badge-warning">Épuisé</span>
                                    </c:when>
                                    <c:when test="${lot.statut == 'EXPIRE'}">
                                        <span class="badge badge-danger">Expiré</span>
                                    </c:when>
                                    <c:when test="${lot.statut == 'BLOQUE'}">
                                        <span class="badge badge-danger">Bloqué</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${lot.statut == 'ACTIF'}">
                                    <button class="btn btn-danger" onclick="bloquerLot(${lot.idLot})">
                                        Bloquer
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty lots}">
                <p style="text-align: center; color: #999; padding: 40px;">Aucun lot trouvé</p>
            </c:if>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">← Retour au Tableau de Bord</a>
            </div>
        </div>
    </div>
</body>
</html>
