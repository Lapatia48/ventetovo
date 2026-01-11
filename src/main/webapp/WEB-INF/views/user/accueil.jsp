<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Ventes - Produits</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3a0ca3;
            --success-color: #4cc9f0;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --gray-color: #6c757d;
            --border-color: #dee2e6;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fb;
            color: var(--dark-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
        }

        .header h1 {
            font-size: 2.2rem;
            margin-bottom: 5px;
        }

        .header p {
            opacity: 0.9;
            font-size: 1.1rem;
        }

        .filter-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
        }

        .filter-card h3 {
            color: var(--secondary-color);
            margin-bottom: 20px;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-card h3 i {
            color: var(--primary-color);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-color);
        }

        .filter-control {
            padding: 12px 15px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .filter-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .filter-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: var(--light-color);
            color: var(--gray-color);
            border: 1px solid var(--border-color);
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            border-radius: 8px;
            background-color: var(--light-color);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--gray-color);
            margin-top: 5px;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            overflow-x: auto;
        }

        .table-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            color: var(--secondary-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .total-count {
            background-color: var(--primary-color);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #f8f9fa;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: var(--dark-color);
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid var(--border-color);
            transition: var(--transition);
        }

        tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }

        .price {
            font-weight: 600;
            font-family: 'Courier New', monospace;
        }

        .price-achat {
            color: #e63946;
        }

        .price-vente {
            color: #2a9d8f;
        }

        .seuil-alerte {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .seuil-normal {
            background-color: #d4edda;
            color: #155724;
        }

        .seuil-bas {
            background-color: #fff3cd;
            color: #856404;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: var(--gray-color);
            font-size: 0.9rem;
            margin-top: 40px;
            border-top: 1px solid var(--border-color);
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.8rem;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-actions {
                flex-direction: column;
            }
            
            .btn {
                justify-content: center;
            }
            
            th, td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête -->
        <div class="header">
            <h1><i class="fas fa-store"></i> Gestion des Ventes</h1>
            <p>Gérez efficacement votre inventaire et vos produits</p>
        </div>

        <!-- Filtres multi-critères -->
        <div class="filter-card">
            <h3><i class="fas fa-filter"></i> Filtres de recherche</h3>
            <form id="filterForm" method="get" action="">
                <div class="filter-grid">
                    <div class="filter-group">
                        <label for="search"><i class="fas fa-search"></i> Recherche générale</label>
                        <input type="text" id="search" name="search" class="filter-control" 
                               placeholder="Code, désignation..." value="${param.search}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="minPrice"><i class="fas fa-tag"></i> Prix min</label>
                        <input type="number" id="minPrice" name="minPrice" class="filter-control" 
                               placeholder="0.00" step="0.01" value="${param.minPrice}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="maxPrice"><i class="fas fa-tags"></i> Prix max</label>
                        <input type="number" id="maxPrice" name="maxPrice" class="filter-control" 
                               placeholder="1000.00" step="0.01" value="${param.maxPrice}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="seuilFilter"><i class="fas fa-exclamation-triangle"></i> Seuil d'alerte</label>
                        <select id="seuilFilter" name="seuilFilter" class="filter-control">
                            <option value="">Tous les produits</option>
                            <option value="low" ${param.seuilFilter == 'low' ? 'selected' : ''}>Stock faible</option>
                            <option value="normal" ${param.seuilFilter == 'normal' ? 'selected' : ''}>Stock normal</option>
                        </select>
                    </div>
                </div>
                
                <div class="filter-actions">
                    <button type="reset" class="btn btn-secondary" id="resetBtn">
                        <i class="fas fa-redo"></i> Réinitialiser
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Appliquer les filtres
                    </button>
                </div>
            </form>
        </div>

        <!-- Statistiques -->
        <div class="stats-card">
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-value">${totalProducts}</div>
                    <div class="stat-label">Produits total</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${lowStockProducts}</div>
                    <div class="stat-label">Stock faible</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${avgPrice}</div>
                    <div class="stat-label">Prix moyen</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${filteredCount}</div>
                    <div class="stat-label">Résultats filtres</div>
                </div>
            </div>
        </div>

        <!-- Tableau des produits -->
        <div class="table-container">
            <div class="table-header">
                <h3><i class="fas fa-boxes"></i> Liste des Produits</h3>
                <div class="total-count">${filteredCount} produits</div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Code</th>
                        <th>Désignation</th>
                        <th>Prix Achat</th>
                        <th>Prix Vente</th>
                        <th>Seuil Alerte</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="article" items="${articles}">
                        <tr data-stock="${stockMap[article.idArticle]}" data-seuil="${article.seuilAlerte}">
                            <td>${article.idArticle}</td>
                            <td><strong>${article.code}</strong></td>
                            <td>${article.designation}</td>
                            <td class="price price-achat">${article.prixAchat} €</td>
                            <td class="price price-vente">${article.prixVente} €</td>
                            <td>${article.seuilAlerte}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${stockMap[article.idArticle] lt article.seuilAlerte}">
                                        <span class="seuil-alerte seuil-bas">Stock faible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="seuil-alerte seuil-normal">Stock normal</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/user/achat/${article.idArticle}" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-success btn-sm" title="Acheter un article">
                                        <i class="fas fa-plus"></i> Acheter
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/user/vente/${article.idArticle}" method="post" style="display: inline; margin-left: 5px;">
                                    <button type="submit" class="btn btn-danger btn-sm" title="Vendre un article">
                                        <i class="fas fa-minus"></i> Vendre
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pied de page -->
        <div class="footer">
            <p>© 2023 Gestion des Ventes - Tous droits réservés</p>
            <p><i class="fas fa-sync-alt"></i> Dernière mise à jour : ${lastUpdate}</p>
        </div>
    </div>

    <script>
        // Réinitialisation des filtres
        document.getElementById('resetBtn').addEventListener('click', function() {
            document.getElementById('filterForm').reset();
            document.getElementById('filterForm').submit();
        });

        // Auto-submit pour certains filtres
        document.getElementById('seuilFilter').addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });

        // Mise en évidence des lignes avec stock faible (compare stock réel au seuil)
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const stock = parseInt(row.dataset.stock || '0');
                const seuil = parseInt(row.dataset.seuil || '0');
                if (!isNaN(stock) && !isNaN(seuil) && stock < seuil) {
                    row.style.backgroundColor = 'rgba(255, 193, 7, 0.1)';
                }
            });
        });

        // Animation au chargement
        document.body.style.opacity = '0';
        window.addEventListener('load', function() {
            document.body.style.transition = 'opacity 0.5s';
            document.body.style.opacity = '1';
        });
    </script>
</body>
</html>