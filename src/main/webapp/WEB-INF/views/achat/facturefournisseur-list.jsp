<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Factures Fournisseurs - Module Achat</title>
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

        /* ===== MESSAGES ===== */
        .success-message { background: rgba(39,174,96,0.1); border: 1px solid rgba(39,174,96,0.2); color: var(--success-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .error-message { background: rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.2); color: var(--danger-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }

        /* ===== FILTERS ===== */
        .filter-container { background: white; border-radius: 8px; box-shadow: var(--shadow); padding: 20px; margin-bottom: 25px; }
        .filter-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 15px; }
        .search-box { position: relative; grid-column: 1 / -1; }
        .search-input { width: 100%; padding: 10px 15px 10px 40px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.9rem; transition: var(--transition); }
        .search-input:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .search-box i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #6c757d; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-label { font-size: 0.85rem; color: #6c757d; margin-bottom: 5px; font-weight: 500; }
        .filter-input, .filter-select { padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.9rem; transition: var(--transition); }
        .filter-input:focus, .filter-select:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .filter-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; padding-top: 15px; border-top: 1px solid var(--border-color); }
        .btn-primary, .btn-secondary { padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.9rem; font-weight: 500; transition: var(--transition); }
        .btn-primary { background: var(--secondary-color); color: white; }
        .btn-primary:hover { background: #2980b9; }
        .btn-secondary { background: var(--light-bg); color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #e9ecef; border-color: var(--secondary-color); }

        /* ===== TABLE ===== */
        .table-container { background: white; border-radius: 8px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 25px; }
        .modern-table { width: 100%; border-collapse: collapse; }
        .modern-table thead { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-bottom: 2px solid var(--border-color); }
        .modern-table th { padding: 16px; text-align: left; font-weight: 600; color: var(--primary-color); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .modern-table td { padding: 16px; border-bottom: 1px solid var(--border-color); font-size: 0.9rem; }
        .modern-table tbody tr:hover { background: rgba(52,152,219,0.04); }

        /* ===== STATUS BADGES ===== */
        .statut-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .statut-en_attente { background-color: rgba(243,156,18,0.15); color: var(--warning-color); border: 1px solid rgba(243,156,18,0.3); }
        .statut-reglee { background-color: rgba(39,174,96,0.15); color: var(--success-color); border: 1px solid rgba(39,174,96,0.3); }
        .statut-en_retard { background-color: rgba(231,76,60,0.15); color: var(--danger-color); border: 1px solid rgba(231,76,60,0.3); }
        .statut-annulee { background-color: rgba(108,117,125,0.15); color: #6c757d; border: 1px solid rgba(108,117,125,0.3); }

        /* ===== WARNING BADGE ===== */
        .retard-badge { display: inline-flex; align-items: center; gap: 5px; background: rgba(231,76,60,0.1); color: var(--danger-color); padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; margin-left: 8px; }
        .retard-badge i { font-size: 0.7rem; }

        /* ===== ACTION BUTTONS ===== */
        .btn-action { display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: var(--secondary-color); color: white; text-decoration: none; border-radius: 6px; font-size: 0.8rem; transition: var(--transition); }
        .btn-action:hover { background: #2980b9; transform: translateY(-1px); }
        .btn-action-detail { background: var(--info-color); }
        .btn-action-detail:hover { background: #138496; }
        .btn-action-regler { background: var(--success-color); }
        .btn-action-regler:hover { background: #219653; }

        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 3rem; color: #dee2e6; margin-bottom: 15px; }
        .empty-state h3 { color: #6c757d; font-size: 1.2rem; margin-bottom: 10px; }
        .empty-state p { color: #6c757d; font-size: 0.95rem; }

        /* ===== TABLE FOOTER ===== */
        .table-footer { padding: 15px 20px; background: white; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .table-info { font-size: 0.9rem; color: #6c757d; }
        .table-info span { font-weight: 600; color: var(--primary-color); }
        .financial-summary { display: flex; gap: 20px; }
        .total-amount { font-size: 1.1rem; font-weight: 600; color: var(--primary-color); }
        .pending-amount { color: var(--warning-color); }
        .overdue-amount { color: var(--danger-color); }

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
            .filter-actions { flex-direction: column; }
            .modern-table { display: block; overflow-x: auto; }
            .table-footer { flex-direction: column; gap: 15px; align-items: flex-start; }
            .financial-summary { flex-direction: column; gap: 10px; }
            .nav-links { flex-direction: column; gap: 10px; }
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
                        <span>Factures fournisseurs</span> / <span>Liste</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <div class="content-header">
                    <h2>Factures Fournisseurs</h2>
                </div>
                
                <!-- MESSAGES -->
                <c:if test="${not empty success}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>${success}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                
                <!-- FILTRES -->
                <div class="filter-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="globalSearch" placeholder="Recherche globale..." class="search-input">
                    </div>
                    
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label class="filter-label">N° Facture</label>
                            <input type="text" id="filterNumero" class="filter-input" placeholder="Filtrer par N°">
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">N° BC</label>
                            <input type="text" id="filterBC" class="filter-input" placeholder="Filtrer par N° BC">
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Fournisseur</label>
                            <input type="text" id="filterFournisseur" class="filter-input" placeholder="Filtrer par fournisseur">
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Statut</label>
                            <select id="filterStatut" class="filter-select">
                                <option value="">Tous les statuts</option>
                                <option value="en_attente">En attente</option>
                                <option value="reglee">Réglée</option>
                                <option value="en_retard">En retard</option>
                                <option value="annulee">Annulée</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="filter-actions">
                        <button id="applyFilters" class="btn-primary">Appliquer</button>
                        <button id="resetFilters" class="btn-secondary">Réinitialiser</button>
                    </div>
                </div>
                
                <!-- TABLEAU -->
                <div class="table-container">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>N° Facture</th>
                                <th>N° BC</th>
                                <th>Fournisseur</th>
                                <th>Date Facture</th>
                                <th>Échéance</th>
                                <th>Montant</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="facturesTable">
                            <c:choose>
                                <c:when test="${not empty factures}">
                                    <c:forEach var="facture" items="${factures}">
                                        <tr>
                                            <td><strong>${facture.numeroFacture}</strong></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/bc/detail/${facture.idBonCommande}" 
                                                   style="color: var(--secondary-color); text-decoration: none; font-weight: 500;">
                                                    <i class="fas fa-file-contract"></i>
                                                    BC #${facture.idBonCommande}
                                                </a>
                                            </td>
                                            <td>
                                                <c:if test="${not empty facture.bonCommande && not empty facture.bonCommande.proforma && not empty facture.bonCommande.proforma.fournisseur}">
                                                    ${facture.bonCommande.proforma.fournisseur.nom}
                                                </c:if>
                                                <c:if test="${empty facture.bonCommande || empty facture.bonCommande.proforma || empty facture.bonCommande.proforma.fournisseur}">
                                                    -
                                                </c:if>
                                            </td>
                                            <td>${facture.dateFacture}</td>
                                            <td>
                                                ${facture.dateEcheance}
                                                <c:if test="${facture.statut == 'EN_RETARD'}">
                                                    <span class="retard-badge">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        En retard
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td><strong>${facture.montantTotal} Ar</strong></td>
                                            <td>
                                                <span class="statut-badge statut-${facture.statut.toLowerCase()}">
                                                    ${facture.statut}
                                                </span>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 8px;">
                                                    <a href="${pageContext.request.contextPath}/factureFournisseur/detail/${facture.idFacture}" 
                                                       class="btn-action btn-action-detail">
                                                        <i class="fas fa-eye"></i>
                                                        Détail
                                                    </a>
                                                    
                                                    <c:if test="${facture.statut == 'EN_ATTENTE'}">
                                                        <form action="${pageContext.request.contextPath}/factureFournisseur/regler" 
                                                              method="post" style="display: inline;">
                                                            <input type="hidden" name="idFacture" value="${facture.idFacture}">
                                                            <button type="submit" class="btn-action btn-action-regler">
                                                                <i class="fas fa-check"></i>
                                                                Régler
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8">
                                            <div class="empty-state">
                                                <i class="fas fa-file-invoice"></i>
                                                <h3>Aucune facture trouvée</h3>
                                                <p>Il n'y a actuellement aucune facture dans le système.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <!-- PIED DE TABLE -->
                <div class="table-footer">
                    <div class="table-info">
                        <span id="rowCount">${not empty factures ? factures.size() : 0}</span> factures trouvées
                    </div>
                    
                    <div class="financial-summary">
                        <c:set var="totalMontant" value="0" />
                        <c:set var="montantEnAttente" value="0" />
                        <c:set var="montantEnRetard" value="0" />
                        
                        <c:forEach var="facture" items="${factures}">
                            <c:set var="totalMontant" value="${totalMontant + facture.montantTotal}" />
                            <c:if test="${facture.statut == 'EN_ATTENTE'}">
                                <c:set var="montantEnAttente" value="${montantEnAttente + facture.montantTotal}" />
                            </c:if>
                            <c:if test="${facture.statut == 'EN_RETARD'}">
                                <c:set var="montantEnRetard" value="${montantEnRetard + facture.montantTotal}" />
                            </c:if>
                        </c:forEach>
                        
                        <div class="total-amount">
                            Total: <strong>${totalMontant} Ar</strong>
                        </div>
                        <c:if test="${montantEnAttente > 0}">
                            <div class="total-amount pending-amount">
                                En attente: <strong>${montantEnAttente} Ar</strong>
                            </div>
                        </c:if>
                        <c:if test="${montantEnRetard > 0}">
                            <div class="total-amount overdue-amount">
                                En retard: <strong>${montantEnRetard} Ar</strong>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- NAVIGATION -->
                <div class="navigation-footer">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/bc/list" class="nav-link-page">
                            <i class="fas fa-arrow-left"></i>
                            Retour aux bons de commande
                        </a>
                        <a href="${pageContext.request.contextPath}/bonLivraison/list" class="nav-link-page">
                            <i class="fas fa-truck"></i>
                            Bons de livraison
                        </a>
                        <a href="${pageContext.request.contextPath}/achat/achat" class="nav-link-page">
                            <i class="fas fa-home"></i>
                            Menu achat
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        // Script de filtrage multicritères
        document.addEventListener('DOMContentLoaded', function() {
            const applyFilters = document.getElementById('applyFilters');
            const resetFilters = document.getElementById('resetFilters');
            const globalSearch = document.getElementById('globalSearch');
            const facturesTable = document.getElementById('facturesTable');
            const rowCount = document.getElementById('rowCount');
            
            let originalRows = Array.from(facturesTable.querySelectorAll('tr')).filter(row => !row.querySelector('.empty-state'));
            
            function applyFiltering() {
                const filterNumero = document.getElementById('filterNumero').value.toLowerCase();
                const filterBC = document.getElementById('filterBC').value.toLowerCase();
                const filterFournisseur = document.getElementById('filterFournisseur').value.toLowerCase();
                const filterStatut = document.getElementById('filterStatut').value.toLowerCase();
                const globalSearchTerm = globalSearch.value.toLowerCase();
                
                let visibleCount = 0;
                
                originalRows.forEach(row => {
                    const numero = row.cells[0].textContent.toLowerCase();
                    const bc = row.cells[1].textContent.toLowerCase();
                    const fournisseur = row.cells[2].textContent.toLowerCase();
                    const statut = row.cells[6].querySelector('.statut-badge').textContent.toLowerCase().trim();
                    
                    let matches = true;
                    
                    if (filterNumero && !numero.includes(filterNumero)) matches = false;
                    if (filterBC && !bc.includes(filterBC)) matches = false;
                    if (filterFournisseur && !fournisseur.includes(filterFournisseur)) matches = false;
                    if (filterStatut && statut !== filterStatut) matches = false;
                    
                    if (globalSearchTerm && 
                        !numero.includes(globalSearchTerm) && 
                        !bc.includes(globalSearchTerm) && 
                        !fournisseur.includes(globalSearchTerm) &&
                        !statut.includes(globalSearchTerm)) {
                        matches = false;
                    }
                    
                    row.style.display = matches ? '' : 'none';
                    if (matches) visibleCount++;
                });
                
                const emptyRow = facturesTable.querySelector('.empty-state');
                if (emptyRow) {
                    if (visibleCount === 0 && (filterNumero || filterBC || filterFournisseur || filterStatut || globalSearchTerm)) {
                        emptyRow.closest('tr').style.display = '';
                        emptyRow.querySelector('h3').textContent = 'Aucun résultat ne correspond à vos critères';
                        emptyRow.querySelector('p').textContent = 'Essayez de modifier vos filtres de recherche';
                    } else if (visibleCount === 0) {
                        emptyRow.closest('tr').style.display = '';
                    } else {
                        emptyRow.closest('tr').style.display = 'none';
                    }
                }
                
                rowCount.textContent = visibleCount;
                
                // Mettre à jour les totaux financiers
                updateFinancialSummary(visibleCount);
            }
            
            function updateFinancialSummary(visibleCount) {
                // Cette fonction pourrait être étendue pour recalculer les totaux
                // basés sur les factures visibles après filtrage
                // Pour l'instant, on garde les totaux initiaux
            }
            
            applyFilters.addEventListener('click', applyFiltering);
            resetFilters.addEventListener('click', function() {
                document.getElementById('filterNumero').value = '';
                document.getElementById('filterBC').value = '';
                document.getElementById('filterFournisseur').value = '';
                document.getElementById('filterStatut').value = '';
                globalSearch.value = '';
                applyFiltering();
            });
            
            globalSearch.addEventListener('keyup', applyFiltering);
            ['filterNumero', 'filterBC', 'filterFournisseur'].forEach(id => {
                document.getElementById(id).addEventListener('keyup', applyFiltering);
            });
            document.getElementById('filterStatut').addEventListener('change', applyFiltering);
            
            applyFiltering();
        });
    </script>
</body>
</html>