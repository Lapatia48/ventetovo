<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comparaison des Proformas - Module Achat</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* ===== VARIABLES CSS ===== */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --sidebar-bg: #1a252f;
            --sidebar-text: #ecf0f1;
            --border-color: #dee2e6;
            --shadow: 0 2px 10px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        /* ===== RESET & BASE ===== */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background-color: #f5f7fa; color: #333; line-height: 1.6; }

        /* ===== SIDEBAR STYLES ===== */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            color: var(--sidebar-text);
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }
        .sidebar-header { padding: 25px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .logo { font-size: 1.5rem; font-weight: 600; color: white; margin-bottom: 20px; }
        .user-info { display: flex; align-items: center; gap: 12px; }
        .user-avatar { width: 40px; height: 40px; background: var(--secondary-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .avatar-initials { font-weight: 600; font-size: 1rem; color: white; }
        .user-details { flex: 1; }
        .user-name { font-weight: 600; font-size: 0.9rem; }
        .user-role { font-size: 0.8rem; opacity: 0.8; margin-top: 2px; }
        .sidebar-nav { flex: 1; padding: 20px 0; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 5px; }
        .nav-link { display: flex; align-items: center; padding: 12px 20px; color: var(--sidebar-text); text-decoration: none; transition: var(--transition); border-left: 3px solid transparent; }
        .nav-link:hover { background: rgba(255,255,255,0.1); border-left-color: var(--secondary-color); }
        .nav-link.active { background: rgba(255,255,255,0.15); border-left-color: var(--secondary-color); }
        .nav-icon { margin-right: 12px; display: flex; align-items: center; width: 20px; }
        .nav-text { font-size: 0.9rem; }
        .sidebar-footer { padding: 20px; border-top: 1px solid rgba(255,255,255,0.1); }
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: var(--sidebar-text); text-decoration: none; background: rgba(231, 76, 60, 0.2); border-radius: 6px; transition: var(--transition); }
        .logout-btn:hover { background: rgba(231, 76, 60, 0.3); }

        /* ===== MAIN CONTENT ===== */
        .main-content { margin-left: 260px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .main-header { background: white; border-bottom: 1px solid var(--border-color); box-shadow: var(--shadow); padding: 0 30px; }
        .header-content { display: flex; justify-content: space-between; align-items: center; padding: 20px 0; }
        .page-title { font-size: 1.8rem; color: var(--primary-color); font-weight: 600; }
        .breadcrumb { font-size: 0.9rem; color: #6c757d; }
        .breadcrumb span { color: var(--secondary-color); font-weight: 500; }
        .breadcrumb span:last-child { color: #6c757d; }

        /* ===== CONTENT WRAPPER ===== */
        .content-wrapper { padding: 30px; flex: 1; }
        .content-header { margin-bottom: 30px; }
        .content-header h2 { font-size: 1.5rem; color: var(--primary-color); margin-bottom: 20px; }

        /* ===== ARTICLE INFO ===== */
        .article-info-card { background: white; border-radius: 10px; box-shadow: var(--shadow); padding: 25px; margin-bottom: 30px; }
        .article-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .info-item { margin-bottom: 15px; }
        .info-label { font-size: 0.85rem; color: #6c757d; font-weight: 500; margin-bottom: 5px; text-transform: uppercase; }
        .info-value { font-size: 1rem; color: #333; }
        .token-badge { display: inline-block; background: rgba(108,117,125,0.1); color: #6c757d; padding: 4px 12px; border-radius: 20px; font-family: monospace; font-size: 0.9rem; margin-left: 10px; }
        
        /* ===== FILTERS ===== */
        .filter-container { background: white; border-radius: 8px; box-shadow: var(--shadow); padding: 20px; margin-bottom: 25px; }
        .filter-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 15px; }
        .search-box { position: relative; grid-column: 1 / -1; }
        .search-input { width: 100%; padding: 10px 15px 10px 40px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.9rem; transition: var(--transition); }
        .search-input:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .search-box i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #6c757d; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-label { font-size: 0.85rem; color: #6c757d; margin-bottom: 5px; font-weight: 500; }
        .filter-select { padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.9rem; transition: var(--transition); }
        .filter-select:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .filter-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; padding-top: 15px; border-top: 1px solid var(--border-color); }
        .btn-primary, .btn-secondary { padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.9rem; font-weight: 500; transition: var(--transition); }
        .btn-primary { background: var(--secondary-color); color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-secondary { background: var(--light-bg); color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #e9ecef; border-color: var(--secondary-color); }

        /* ===== COMPARISON TABLE ===== */
        .comparison-container { background: white; border-radius: 10px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 25px; }
        .comparison-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .comparison-header h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .comparison-header h3 i { color: var(--info-color); }
        .comparison-body { padding: 0; }
        
        /* ===== TABLE STYLES ===== */
        .comparison-table { width: 100%; border-collapse: collapse; }
        .comparison-table thead { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }
        .comparison-table th { padding: 16px; text-align: left; font-weight: 600; color: var(--primary-color); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid var(--border-color); }
        .comparison-table td { padding: 16px; border-bottom: 1px solid var(--border-color); font-size: 0.9rem; }
        .comparison-table tbody tr { transition: var(--transition); }
        .comparison-table tbody tr:hover { background: rgba(52,152,219,0.04); }

        /* ===== STATUS STYLES ===== */
        .row-selectionne { background-color: rgba(39,174,96,0.08); }
        .row-en_attente { background-color: rgba(243,156,18,0.05); }
        .row-rejete { background-color: rgba(231,76,60,0.05); }
        .row-prix-min { background: linear-gradient(90deg, rgba(39,174,96,0.1) 0%, rgba(39,174,96,0.2) 100%) !important; }
        .row-prix-min td { font-weight: 600; }
        
        /* ===== PRICE STYLES ===== */
        .price-min { color: var(--success-color) !important; font-weight: 700 !important; font-size: 1.05rem !important; }
        .price-cell { font-weight: 600; color: var(--primary-color); }
        .amount-cell { font-weight: 600; color: var(--info-color); }
        
        /* ===== STATUS BADGES ===== */
        .status-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .status-selectionne { background-color: rgba(39,174,96,0.15); color: var(--success-color); border: 1px solid rgba(39,174,96,0.3); }
        .status-en_attente { background-color: rgba(243,156,18,0.15); color: var(--warning-color); border: 1px solid rgba(243,156,18,0.3); }
        .status-rejete { background-color: rgba(231,76,60,0.15); color: var(--danger-color); border: 1px solid rgba(231,76,60,0.3); }

        /* ===== ACTION BUTTONS ===== */
        .action-cell { white-space: nowrap; }
        .btn-select { display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: var(--success-color); color: white; text-decoration: none; border: none; border-radius: 6px; font-size: 0.85rem; cursor: pointer; transition: var(--transition); }
        .btn-select:hover { background: #219653; transform: translateY(-1px); }
        .selected-badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: rgba(39,174,96,0.15); color: var(--success-color); border-radius: 6px; font-size: 0.85rem; font-weight: 600; }
        .info-message { display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; color: #6c757d; font-size: 0.85rem; margin-left: 10px; }
        
        /* ===== BEST PRICE BANNER ===== */
        .best-price-banner { background: linear-gradient(135deg, rgba(39,174,96,0.1) 0%, rgba(39,174,96,0.2) 100%); border: 1px solid rgba(39,174,96,0.3); border-radius: 8px; padding: 15px 20px; margin: 20px 0; display: flex; align-items: center; gap: 15px; }
        .best-price-banner i { font-size: 1.5rem; color: var(--success-color); }
        .best-price-banner div { flex: 1; }
        .best-price-banner strong { color: var(--success-color); }
        .best-price-amount { font-size: 1.3rem; font-weight: 700; color: var(--success-color); margin-left: 10px; }

        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 3rem; color: #dee2e6; margin-bottom: 15px; }
        .empty-state h3 { color: #6c757d; font-size: 1.2rem; margin-bottom: 10px; }
        .empty-state p { color: #6c757d; font-size: 0.95rem; }

        /* ===== TABLE FOOTER ===== */
        .table-footer { padding: 15px 20px; background: white; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .table-info { font-size: 0.9rem; color: #6c757d; }
        .table-info span { font-weight: 600; color: var(--primary-color); }

        /* ===== NAVIGATION ===== */
        .navigation-footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--border-color); }
        .nav-links { display: flex; gap: 20px; }
        .nav-link-page { display: inline-flex; align-items: center; gap: 8px; color: var(--secondary-color); text-decoration: none; font-weight: 500; transition: var(--transition); }
        .nav-link-page:hover { color: #2980b9; gap: 12px; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 992px) {
            .sidebar { width: 70px; }
            .nav-text, .user-name, .user-role, .logo { display: none; }
            .nav-link { justify-content: center; padding: 15px; }
            .nav-icon { margin-right: 0; }
            .main-content { margin-left: 70px; }
        }
        @media (max-width: 768px) {
            .sidebar { width: 100%; height: auto; position: static; }
            .main-content { margin-left: 0; }
            .filter-grid { grid-template-columns: 1fr; }
            .article-grid { grid-template-columns: 1fr; }
            .comparison-table { display: block; overflow-x: auto; }
            .table-footer { flex-direction: column; gap: 15px; align-items: flex-start; }
            .nav-links { flex-direction: column; gap: 10px; }
            .action-cell { white-space: normal; }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- SIDEBAR -->
        <%@ include file="../achat/sidebar.jsp" %>
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <header class="main-header">
                <div class="header-content">
                    <h1 class="page-title">Module d'Achat</h1>
                    <div class="breadcrumb">
                        <span>Proformas</span> / <span>Comparaison</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <div class="content-header">
                    <h2>Comparaison des Proformas</h2>
                </div>
                
                <!-- ARTICLE INFO -->
                <c:if test="${not empty article}">
                    <div class="article-info-card">
                        <div class="article-grid">
                            <div class="info-item">
                                <div class="info-label">Article</div>
                                <div class="info-value">
                                    <strong>${article.code}</strong> - ${article.designation}
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Quantité demandée</div>
                                <div class="info-value">
                                    <strong style="font-size: 1.2rem;">${quantite}</strong> unités
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Token de la demande</div>
                                <div class="info-value">
                                    <span class="token-badge">${tokenDemande}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- BEST PRICE BANNER -->
                <c:if test="${not empty proformas}">
                    <div id="bestPriceBanner" class="best-price-banner" style="display: none;">
                        <i class="fas fa-trophy"></i>
                        <div>
                            <strong>MEILLEUR PRIX IDENTIFIÉ</strong>
                            <div style="margin-top: 5px;">
                                <span id="bestPriceSupplier"></span>
                                <span id="bestPriceAmount" class="best-price-amount"></span>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- FILTERS -->
                <div class="filter-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="globalSearch" placeholder="Rechercher par fournisseur, numéro ou prix..." class="search-input">
                    </div>
                    
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label class="filter-label">Statut</label>
                            <select id="filterStatut" class="filter-select">
                                <option value="">Tous les statuts</option>
                                <option value="en_attente">En attente</option>
                                <option value="selectionne">Sélectionné</option>
                                <option value="rejete">Rejeté</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Trier par</label>
                            <select id="sortBy" class="filter-select">
                                <option value="prix">Prix croissant</option>
                                <option value="prix_desc">Prix décroissant</option>
                                <option value="date">Date récente</option>
                                <option value="fournisseur">Fournisseur</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="filter-actions">
                        <button id="applyFilters" class="btn-primary">Filtrer</button>
                        <button id="resetFilters" class="btn-secondary">Réinitialiser</button>
                    </div>
                </div>
                
                <!-- COMPARISON TABLE -->
                <div class="comparison-container">
                    <div class="comparison-header">
                        <h3><i class="fas fa-balance-scale"></i> Comparaison des Prix</h3>
                    </div>
                    <div class="comparison-body">
                        <table class="comparison-table" id="proformasTable">
                            <thead>
                                <tr>
                                    <th>N° Proforma</th>
                                    <th>Fournisseur</th>
                                    <th>Prix Unitaire</th>
                                    <th>Quantité</th>
                                    <th>Montant Total</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="proformasTableBody">
                                <c:choose>
                                    <c:when test="${not empty proformas}">
                                        <c:forEach var="proforma" items="${proformas}" varStatus="status">
                                            <tr class="row-${proforma.statut.toLowerCase().replace('é', 'e')}" 
                                                data-prix="${proforma.prixUnitaire}"
                                                data-id="${proforma.idProforma}"
                                                data-status="${proforma.statut.toLowerCase().replace('é', 'e')}"
                                                data-fournisseur="${proforma.fournisseur != null ? proforma.fournisseur.nom : ''}"
                                                data-date="${proforma.dateProforma}">
                                                <td><strong>${proforma.numero}</strong></td>
                                                <td>
                                                    <c:if test="${not empty proforma.fournisseur}">
                                                        ${proforma.fournisseur.nom}
                                                    </c:if>
                                                    <c:if test="${empty proforma.fournisseur}">
                                                        Fournisseur #${proforma.idFournisseur}
                                                    </c:if>
                                                </td>
                                                <td class="price-cell">${proforma.prixUnitaire} Ar</td>
                                                <td>${proforma.quantite}</td>
                                                <td class="amount-cell">${proforma.montantTotal} Ar</td>
                                                <td>${proforma.dateProforma}</td>
                                                <td>
                                                    <span class="status-badge status-${proforma.statut.toLowerCase().replace('é', 'e')}">
                                                        ${proforma.statut}
                                                    </span>
                                                </td>
                                                <td class="action-cell">
                                                    <c:if test="${proforma.statut == 'EN_ATTENTE'}">
                                                        <form action="${pageContext.request.contextPath}/achat/selectionner" 
                                                              method="post" style="display: inline;" 
                                                              class="selection-form" data-proforma-id="${proforma.idProforma}">
                                                            <input type="hidden" name="idProforma" value="${proforma.idProforma}">
                                                            <input type="hidden" name="tokenDemande" value="${tokenDemande}">
                                                            <button type="submit" class="btn-select">
                                                                <i class="fas fa-check"></i>
                                                                Sélectionner
                                                            </button>
                                                        </form>
                                                        <span class="info-message" id="info-${proforma.idProforma}"></span>
                                                    </c:if>
                                                    <c:if test="${proforma.statut == 'SELECTIONNE'}">
                                                        <span class="selected-badge">
                                                            <i class="fas fa-check-circle"></i>
                                                            Sélectionné
                                                        </span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div class="empty-state">
                                                    <i class="fas fa-file-invoice"></i>
                                                    <h3>Aucun proforma disponible</h3>
                                                    <p>Il n'y a actuellement aucun proforma à comparer pour cet article.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- TABLE FOOTER -->
                <div class="table-footer">
                    <div class="table-info">
                        <span id="rowCount">${not empty proformas ? proformas.size() : 0}</span> proforma(s) trouvé(s)
                    </div>
                </div>
                
                <!-- NAVIGATION -->
                <div class="navigation-footer">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/achat/achat" class="nav-link-page">
                            <i class="fas fa-arrow-left"></i>
                            Retour à la liste des articles
                        </a>
                        <a href="${pageContext.request.contextPath}/achat/demandes" class="nav-link-page">
                            <i class="fas fa-clipboard-list"></i>
                            Voir toutes les demandes
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const proformasTable = document.getElementById('proformasTable');
            const proformasTableBody = document.getElementById('proformasTableBody');
            const globalSearch = document.getElementById('globalSearch');
            const filterStatut = document.getElementById('filterStatut');
            const sortBy = document.getElementById('sortBy');
            const applyFilters = document.getElementById('applyFilters');
            const resetFilters = document.getElementById('resetFilters');
            const rowCount = document.getElementById('rowCount');
            const bestPriceBanner = document.getElementById('bestPriceBanner');
            
            let originalRows = Array.from(proformasTableBody.querySelectorAll('tr')).filter(row => !row.querySelector('.empty-state'));
            
            // Initialiser la comparaison des prix
            comparerPrix();
            
            function comparerPrix() {
                const rows = originalRows;
                const enAttenteRows = [];
                let minPrix = Infinity;
                let minPrixRow = null;
                let minPrixSupplier = '';
                let minPrixAmount = '';
                
                rows.forEach(row => {
                    const prixValue = parseFloat(row.getAttribute('data-prix'));
                    const status = row.getAttribute('data-status');
                    
                    if (!isNaN(prixValue)) {
                        if (status === 'en_attente') {
                            enAttenteRows.push(row);
                            
                            if (prixValue < minPrix) {
                                minPrix = prixValue;
                                minPrixRow = row;
                                minPrixSupplier = row.cells[1].textContent.trim();
                                minPrixAmount = row.cells[2].textContent.trim();
                            }
                        }
                    }
                });
                
                // Mettre en évidence le prix minimum
                if (minPrixRow) {
                    minPrixRow.classList.add('row-prix-min');
                    minPrixRow.querySelector('.price-cell').classList.add('price-min');
                    
                    // Afficher le banner du meilleur prix
                    if (bestPriceBanner) {
                        document.getElementById('bestPriceSupplier').textContent = minPrixSupplier + ' : ';
                        document.getElementById('bestPriceAmount').textContent = minPrixAmount;
                        bestPriceBanner.style.display = 'flex';
                    }
                    
                    // Désactiver les autres boutons de sélection
                    enAttenteRows.forEach(row => {
                        if (row !== minPrixRow) {
                            const selectBtn = row.querySelector('.btn-select');
                            const infoSpan = row.querySelector('.info-message');
                            if (selectBtn) {
                                selectBtn.style.display = 'none';
                                if (infoSpan) {
                                    infoSpan.innerHTML = '<i class="fas fa-info-circle"></i> Prix plus élevé';
                                }
                            }
                        } else {
                            // Ajouter une indication pour le meilleur prix
                            const selectBtn = minPrixRow.querySelector('.btn-select');
                            if (selectBtn) {
                                selectBtn.innerHTML = '<i class="fas fa-trophy"></i> Sélectionner (Meilleur prix)';
                                selectBtn.style.background = 'linear-gradient(135deg, var(--success-color) 0%, #219653 100%)';
                            }
                        }
                    });
                }
            }
            
            function applyFiltering() {
                const searchTerm = globalSearch.value.toLowerCase();
                const statutFilter = filterStatut.value.toLowerCase();
                const sortValue = sortBy.value;
                
                let visibleRows = [];
                
                originalRows.forEach(row => {
                    const numero = row.cells[0].textContent.toLowerCase();
                    const fournisseur = row.cells[1].textContent.toLowerCase();
                    const prix = row.cells[2].textContent.toLowerCase();
                    const statut = row.getAttribute('data-status');
                    
                    let matches = true;
                    
                    // Filtre par recherche
                    if (searchTerm && 
                        !numero.includes(searchTerm) && 
                        !fournisseur.includes(searchTerm) && 
                        !prix.includes(searchTerm)) {
                        matches = false;
                    }
                    
                    // Filtre par statut
                    if (statutFilter && statut !== statutFilter) {
                        matches = false;
                    }
                    
                    if (matches) {
                        visibleRows.push(row);
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
                
                // Tri des résultats
                if (sortValue) {
                    visibleRows.sort((a, b) => {
                        switch(sortValue) {
                            case 'prix':
                                return parseFloat(a.getAttribute('data-prix')) - parseFloat(b.getAttribute('data-prix'));
                            case 'prix_desc':
                                return parseFloat(b.getAttribute('data-prix')) - parseFloat(a.getAttribute('data-prix'));
                            case 'date':
                                return new Date(b.getAttribute('data-date')) - new Date(a.getAttribute('data-date'));
                            case 'fournisseur':
                                return a.getAttribute('data-fournisseur').localeCompare(b.getAttribute('data-fournisseur'));
                            default:
                                return 0;
                        }
                    });
                    
                    // Réorganiser les lignes dans le DOM
                    visibleRows.forEach(row => {
                        proformasTableBody.appendChild(row);
                    });
                }
                
                // Mettre à jour le compteur
                rowCount.textContent = visibleRows.length;
                
                // Recalculer le meilleur prix parmi les lignes visibles
                comparerPrix();
            }
            
            // Événements
            applyFilters.addEventListener('click', applyFiltering);
            resetFilters.addEventListener('click', function() {
                globalSearch.value = '';
                filterStatut.value = '';
                sortBy.value = 'prix';
                applyFiltering();
            });
            
            globalSearch.addEventListener('keyup', applyFiltering);
            filterStatut.addEventListener('change', applyFiltering);
            sortBy.addEventListener('change', applyFiltering);
            
            // Confirmation pour la sélection
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('btn-select')) {
                    const form = e.target.closest('form');
                    const proformaId = form.getAttribute('data-proforma-id');
                    
                    // Afficher une confirmation
                    if (!confirm('Êtes-vous sûr de vouloir sélectionner cette proforma ? Cette action est irréversible.')) {
                        e.preventDefault();
                    }
                }
            });
            
            // Initialisation
            applyFiltering();
        });
    </script>
</body>
</html>