<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Module Achat - Gestion des articles</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Variables CSS */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --light-bg: #f8f9fa;
            --sidebar-bg: #1a252f;
            --sidebar-text: #ecf0f1;
            --border-color: #dee2e6;
            --shadow: 0 2px 10px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        /* Reset et styles de base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        /* Container principal */
        .app-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            color: var(--sidebar-text);
            display: flex;
            flex-direction: column;
            transition: var(--transition);
        }

        .sidebar-header {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 600;
            color: white;
            margin-bottom: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--secondary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .avatar-initials {
            font-weight: 600;
            font-size: 1rem;
            color: white;
        }

        .user-details {
            flex: 1;
        }

        .user-name {
            font-weight: 600;
            font-size: 0.9rem;
        }

        .user-role {
            font-size: 0.8rem;
            opacity: 0.8;
            margin-top: 2px;
        }

        .sidebar-nav {
            flex: 1;
            padding: 20px 0;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--sidebar-text);
            text-decoration: none;
            transition: var(--transition);
            border-left: 3px solid transparent;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.1);
            border-left-color: var(--secondary-color);
        }

        .nav-link.active {
            background: rgba(255,255,255,0.15);
            border-left-color: var(--secondary-color);
        }

        .nav-icon {
            margin-right: 12px;
            display: flex;
            align-items: center;
        }

        .nav-icon svg {
            stroke-width: 1.5;
        }

        .nav-text {
            font-size: 0.9rem;
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .logout-btn {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--sidebar-text);
            text-decoration: none;
            background: rgba(231, 76, 60, 0.2);
            border-radius: 6px;
            transition: var(--transition);
        }

        .logout-btn:hover {
            background: rgba(231, 76, 60, 0.3);
        }

        /* Contenu principal */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .main-header {
            background: white;
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow);
            padding: 0 30px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
        }

        .page-title {
            font-size: 1.8rem;
            color: var(--primary-color);
            font-weight: 600;
        }

        .header-actions {
            display: flex;
            align-items: center;
        }

        .breadcrumb {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .breadcrumb span {
            color: var(--secondary-color);
            font-weight: 500;
        }

        .breadcrumb span:last-child {
            color: #6c757d;
        }

        /* Contenu */
        .content-wrapper {
            padding: 30px;
            flex: 1;
        }

        .content-header {
            margin-bottom: 30px;
        }

        .content-header h2 {
            font-size: 1.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .filter-container {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .multi-filter {
            position: relative;
        }

        .filter-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: var(--primary-color);
            cursor: pointer;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .filter-btn:hover {
            border-color: var(--secondary-color);
            background: #f8f9fa;
        }

        .filter-panel {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 20px;
            margin-top: 10px;
            min-width: 250px;
            box-shadow: var(--shadow);
            display: none;
            z-index: 100;
        }

        .filter-panel.active {
            display: block;
        }

        .filter-group {
            margin-bottom: 15px;
        }

        .filter-group label {
            display: block;
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .filter-input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .filter-input:focus {
            outline: none;
            border-color: var(--secondary-color);
        }

        .filter-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-primary, .btn-secondary {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: var(--transition);
            flex: 1;
        }

        .btn-primary {
            background: var(--secondary-color);
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        /* Table */
        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .modern-table {
            width: 100%;
            border-collapse: collapse;
        }

        .modern-table thead {
            background: #f8f9fa;
            border-bottom: 2px solid var(--border-color);
        }

        .modern-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: var(--primary-color);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .modern-table td {
            padding: 15px;
            border-bottom: 1px solid var(--border-color);
        }

        .modern-table tbody tr {
            transition: var(--transition);
        }

        .modern-table tbody tr:hover {
            background: #f8f9fa;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: var(--success-color);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.85rem;
            transition: var(--transition);
        }

        .btn-action:hover {
            background: #219653;
            transform: translateY(-1px);
        }

        .btn-action i {
            font-size: 0.8rem;
        }

        .empty-message {
            text-align: center;
        }

        .empty-state {
            padding: 40px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state p {
            font-size: 1.1rem;
        }

        .table-footer {
            padding: 15px 20px;
            background: white;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-info {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .table-info span {
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
            }
            
            .nav-text, .user-name, .user-role, .logo {
                display: none;
            }
            
            .nav-link {
                justify-content: center;
                padding: 15px;
            }
            
            .nav-icon {
                margin-right: 0;
            }
            
            .user-info {
                justify-content: center;
            }
            
            .logout-btn {
                justify-content: center;
                padding: 15px;
            }
        }

        @media (max-width: 768px) {
            .app-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
            }
            
            .sidebar-nav .nav-menu {
                display: flex;
                overflow-x: auto;
            }
            
            .nav-item {
                flex-shrink: 0;
                margin-bottom: 0;
                margin-right: 5px;
            }
            
            .nav-link {
                border-left: none;
                border-bottom: 3px solid transparent;
            }
            
            .nav-link:hover,
            .nav-link.active {
                border-left: none;
                border-bottom-color: var(--secondary-color);
            }
            
            .content-wrapper {
                padding: 20px;
            }
            
            .filter-container {
                flex-direction: column;
            }
            
            .search-box {
                max-width: 100%;
            }
            
            .filter-panel {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 90%;
                max-width: 400px;
                max-height: 80vh;
                overflow-y: auto;
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Inclusion de la sidebar -->
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="main-header">
                <div class="header-content">
                    <h1 class="page-title">Module d'Achat</h1>
                    <div class="header-actions">
                        <div class="breadcrumb">
                            <span>Accueil</span> / <span>Articles</span>
                        </div>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <div class="content-header">
                    <h2>Liste des Articles - Demande d'Achat</h2>
                    <div class="content-actions">
                        <div class="filter-container">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="globalSearch" placeholder="Recherche globale..." class="search-input">
                            </div>
                            <div class="multi-filter">
                                <button id="filterToggle" class="filter-btn">
                                    <i class="fas fa-filter"></i>
                                    Filtres multicritères
                                </button>
                                <div id="filterPanel" class="filter-panel">
                                    <div class="filter-group">
                                        <label for="filterId">ID</label>
                                        <input type="text" id="filterId" class="filter-input" placeholder="Filtrer par ID">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filterCode">Code</label>
                                        <input type="text" id="filterCode" class="filter-input" placeholder="Filtrer par code">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filterDesignation">Désignation</label>
                                        <input type="text" id="filterDesignation" class="filter-input" placeholder="Filtrer par désignation">
                                    </div>
                                    <div class="filter-actions">
                                        <button id="applyFilters" class="btn-primary">Appliquer</button>
                                        <button id="resetFilters" class="btn-secondary">Réinitialiser</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="table-container">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Désignation</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="articlesTable">
                            <c:choose>
                                <c:when test="${not empty articles}">
                                    <c:forEach var="article" items="${articles}">
                                        <tr>
                                            <td>${article.idArticle}</td>
                                            <td>${article.code}</td>
                                            <td>${article.designation}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/achat/quantite?idArticle=${article.idArticle}" 
                                                   class="btn-action">
                                                    <i class="fas fa-shopping-cart"></i>
                                                    Demande d'achat
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-message">
                                            <div class="empty-state">
                                                <i class="fas fa-box-open"></i>
                                                <p>Aucun article trouvé</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <div class="table-footer">
                    <div class="table-info">
                        <span id="rowCount">${not empty articles ? articles.size() : 0}</span> articles trouvés
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        // Script pour le filtrage multicritères
        document.addEventListener('DOMContentLoaded', function() {
            const filterToggle = document.getElementById('filterToggle');
            const filterPanel = document.getElementById('filterPanel');
            const applyFilters = document.getElementById('applyFilters');
            const resetFilters = document.getElementById('resetFilters');
            const globalSearch = document.getElementById('globalSearch');
            const articlesTable = document.getElementById('articlesTable');
            const rowCount = document.getElementById('rowCount');
            
            let originalRows = Array.from(articlesTable.querySelectorAll('tr')).filter(row => !row.querySelector('.empty-state'));
            
            // Fermer le panneau de filtres en cliquant en dehors
            document.addEventListener('click', function(event) {
                if (!filterPanel.contains(event.target) && !filterToggle.contains(event.target)) {
                    filterPanel.classList.remove('active');
                }
            });
            
            // Toggle du panneau de filtres
            filterToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                filterPanel.classList.toggle('active');
            });
            
            // Appliquer les filtres
            applyFilters.addEventListener('click', function() {
                applyFiltering();
                filterPanel.classList.remove('active');
            });
            
            // Réinitialiser les filtres
            resetFilters.addEventListener('click', function() {
                document.getElementById('filterId').value = '';
                document.getElementById('filterCode').value = '';
                document.getElementById('filterDesignation').value = '';
                globalSearch.value = '';
                applyFiltering();
                filterPanel.classList.remove('active');
            });
            
            // Recherche globale
            globalSearch.addEventListener('keyup', function() {
                applyFiltering();
            });
            
            // Filtrer les champs individuels
            ['filterId', 'filterCode', 'filterDesignation'].forEach(id => {
                document.getElementById(id).addEventListener('keyup', function() {
                    applyFiltering();
                });
            });
            
            // Permettre l'appui sur Entrée pour appliquer les filtres
            document.querySelectorAll('.filter-input').forEach(input => {
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        applyFiltering();
                        filterPanel.classList.remove('active');
                    }
                });
            });
            
            function applyFiltering() {
                const filterId = document.getElementById('filterId').value.toLowerCase();
                const filterCode = document.getElementById('filterCode').value.toLowerCase();
                const filterDesignation = document.getElementById('filterDesignation').value.toLowerCase();
                const globalSearchTerm = globalSearch.value.toLowerCase();
                
                let visibleCount = 0;
                
                originalRows.forEach(row => {
                    const id = row.cells[0].textContent.toLowerCase();
                    const code = row.cells[1].textContent.toLowerCase();
                    const designation = row.cells[2].textContent.toLowerCase();
                    
                    let matchesFilters = true;
                    
                    // Vérifier les filtres individuels
                    if (filterId && !id.includes(filterId)) matchesFilters = false;
                    if (filterCode && !code.includes(filterCode)) matchesFilters = false;
                    if (filterDesignation && !designation.includes(filterDesignation)) matchesFilters = false;
                    
                    // Vérifier la recherche globale si elle est active
                    if (globalSearchTerm && 
                        !id.includes(globalSearchTerm) && 
                        !code.includes(globalSearchTerm) && 
                        !designation.includes(globalSearchTerm)) {
                        matchesFilters = false;
                    }
                    
                    if (matchesFilters) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });
                
                // Gérer le cas où aucun résultat n'est trouvé
                const emptyRow = articlesTable.querySelector('.empty-message');
                if (emptyRow) {
                    if (visibleCount === 0 && (filterId || filterCode || filterDesignation || globalSearchTerm)) {
                        emptyRow.style.display = '';
                        emptyRow.querySelector('p').textContent = 'Aucun résultat ne correspond à vos critères';
                    } else if (visibleCount === 0) {
                        emptyRow.style.display = '';
                        emptyRow.querySelector('p').textContent = 'Aucun article trouvé';
                    } else {
                        emptyRow.style.display = 'none';
                    }
                }
                
                // Mettre à jour le compteur
                rowCount.textContent = visibleCount;
                
                // Ajouter une classe pour indiquer qu'un filtre est actif
                const hasActiveFilter = filterId || filterCode || filterDesignation || globalSearchTerm;
                filterToggle.classList.toggle('active', hasActiveFilter);
            }
            
            // Initialiser le compteur
            applyFiltering();
        });
    </script>
</body>
</html>