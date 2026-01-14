<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toutes les demandes - Module Achat</title>
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
        .header-actions { display: flex; align-items: center; gap: 15px; }

        /* ===== CONTENT WRAPPER ===== */
        .content-wrapper { padding: 30px; flex: 1; }
        .content-header { margin-bottom: 30px; }
        .content-header h2 { font-size: 1.5rem; color: var(--primary-color); margin-bottom: 20px; }

        /* ===== FILTERS ===== */
        .filter-container { background: white; border-radius: 8px; box-shadow: var(--shadow); padding: 20px; margin-bottom: 25px; }
        .search-box { position: relative; max-width: 400px; }
        .search-input { width: 100%; padding: 10px 15px 10px 40px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.9rem; transition: var(--transition); }
        .search-input:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .search-box i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #6c757d; }

        /* ===== DEMANDES GRID ===== */
        .demandes-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 20px; margin-bottom: 30px; }
        
        /* ===== DEMANDE CARD ===== */
        .demande-card { background: white; border-radius: 10px; box-shadow: var(--shadow); overflow: hidden; transition: var(--transition); border: 1px solid var(--border-color); }
        .demande-card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.15); border-color: var(--secondary-color); }
        
        .demande-header { padding: 20px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .demande-header h3 { color: var(--primary-color); font-size: 1.1rem; font-weight: 600; margin-bottom: 5px; display: flex; align-items: center; justify-content: space-between; }
        .demande-header h3 span { font-size: 0.9rem; color: #6c757d; font-weight: normal; }
        .demande-token { font-family: monospace; background: rgba(108,117,125,0.1); padding: 3px 8px; border-radius: 4px; font-size: 0.8rem; color: #6c757d; }
        
        .demande-body { padding: 20px; }
        .demande-info { margin-bottom: 15px; }
        .demande-label { font-size: 0.85rem; color: #6c757d; margin-bottom: 3px; display: block; }
        .demande-value { font-size: 1rem; color: var(--primary-color); }
        .article-code { display: inline-block; background: var(--info-color); color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; font-weight: 600; margin-right: 8px; }
        
        .demande-footer { padding: 15px 20px; border-top: 1px solid var(--border-color); background: #f8f9fa; display: flex; justify-content: space-between; align-items: center; }
        .proforma-count { display: flex; align-items: center; gap: 8px; color: var(--info-color); font-weight: 500; font-size: 0.9rem; }
        .proforma-count i { font-size: 0.8rem; }
        
        /* ===== ACTION BUTTONS ===== */
        .btn-action { display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background: var(--secondary-color); color: white; text-decoration: none; border-radius: 6px; font-size: 0.85rem; font-weight: 500; transition: var(--transition); }
        .btn-action:hover { background: #2980b9; transform: translateY(-1px); }
        .btn-action i { font-size: 0.8rem; }

        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 10px; box-shadow: var(--shadow); margin: 30px 0; }
        .empty-state i { font-size: 4rem; color: #dee2e6; margin-bottom: 20px; }
        .empty-state h3 { color: #6c757d; font-size: 1.3rem; margin-bottom: 10px; }
        .empty-state p { color: #6c757d; font-size: 1rem; margin-bottom: 25px; max-width: 500px; margin-left: auto; margin-right: auto; }
        .btn-create { display: inline-flex; align-items: center; gap: 10px; padding: 12px 24px; background: var(--success-color); color: white; text-decoration: none; border-radius: 6px; font-weight: 600; transition: var(--transition); }
        .btn-create:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }

        /* ===== STATS ===== */
        .stats-container { background: white; border-radius: 8px; box-shadow: var(--shadow); padding: 20px; margin-bottom: 25px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .stat-item { text-align: center; padding: 15px; border-radius: 8px; }
        .stat-item:nth-child(1) { background: rgba(52,152,219,0.1); border: 1px solid rgba(52,152,219,0.2); }
        .stat-item:nth-child(2) { background: rgba(39,174,96,0.1); border: 1px solid rgba(39,174,96,0.2); }
        .stat-item:nth-child(3) { background: rgba(243,156,18,0.1); border: 1px solid rgba(243,156,18,0.2); }
        .stat-number { font-size: 2rem; font-weight: 700; color: var(--primary-color); margin-bottom: 5px; }
        .stat-label { font-size: 0.9rem; color: #6c757d; }

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
            .demandes-grid { grid-template-columns: 1fr; }
            .stats-grid { grid-template-columns: 1fr; }
            .nav-links { flex-direction: column; gap: 10px; }
            .header-actions { flex-direction: column; align-items: flex-start; gap: 10px; }
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
                    <div class="header-actions">
                        <div class="breadcrumb">
                            <span>Demandes d'achat</span> / <span>Toutes</span>
                        </div>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <div class="content-header">
                    <h2>Toutes les demandes d'achat</h2>
                </div>
                
                <!-- STATISTICS -->
                <div class="stats-container">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">${not empty demandes ? demandes.size() : 0}</div>
                            <div class="stat-label">Demandes totales</div>
                        </div>
                        <c:set var="totalProformas" value="0" />
                        <c:forEach var="demande" items="${demandes}">
                            <c:set var="proformas" value="${demande.value}" />
                            <c:if test="${not empty proformas}">
                                <c:set var="totalProformas" value="${totalProformas + proformas.size()}" />
                            </c:if>
                        </c:forEach>
                        <div class="stat-item">
                            <div class="stat-number">${totalProformas}</div>
                            <div class="stat-label">Proformas reçus</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">
                                <c:set var="demandesAvecProformas" value="0" />
                                <c:forEach var="demande" items="${demandes}">
                                    <c:set var="proformas" value="${demande.value}" />
                                    <c:if test="${not empty proformas && proformas.size() > 0}">
                                        <c:set var="demandesAvecProformas" value="${demandesAvecProformas + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${demandesAvecProformas}
                            </div>
                            <div class="stat-label">Demandes actives</div>
                        </div>
                    </div>
                </div>
                
                <!-- FILTER -->
                <div class="filter-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchDemandes" placeholder="Rechercher par article, code ou quantité..." class="search-input">
                    </div>
                </div>
                
                <!-- DEMANDES LIST -->
                <c:choose>
                    <c:when test="${not empty demandes}">
                        <div class="demandes-grid" id="demandesList">
                            <c:forEach var="demande" items="${demandes}" varStatus="loop">
                                <c:set var="proformas" value="${demande.value}" />
                                <c:if test="${not empty proformas}">
                                    <div class="demande-card" data-search="${proformas[0].article.code} ${proformas[0].article.designation} ${proformas[0].quantite}">
                                        <div class="demande-header">
                                            <h3>
                                                Demande #${loop.index + 1}
                                                <span class="demande-token">${proformas[0].tokenDemande}</span>
                                            </h3>
                                        </div>
                                        
                                        <div class="demande-body">
                                            <div class="demande-info">
                                                <span class="demande-label">Article</span>
                                                <span class="demande-value">
                                                    <c:if test="${not empty proformas[0].article}">
                                                        <span class="article-code">${proformas[0].article.code}</span>
                                                        ${proformas[0].article.designation}
                                                    </c:if>
                                                </span>
                                            </div>
                                            
                                            <div class="demande-info">
                                                <span class="demande-label">Quantité demandée</span>
                                                <span class="demande-value">
                                                    <strong style="color: var(--primary-color); font-size: 1.1rem;">${proformas[0].quantite}</strong> unités
                                                </span>
                                            </div>
                                            
                                            <div class="demande-info">
                                                <span class="demande-label">Date création</span>
                                                <span class="demande-value">
                                                    <c:if test="${not empty proformas[0].dateCreation}">
                                                        ${proformas[0].dateCreation}
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="demande-footer">
                                            <div class="proforma-count">
                                                <i class="fas fa-file-invoice"></i>
                                                ${proformas.size()} proforma(s)
                                            </div>
                                            <a href="${pageContext.request.contextPath}/achat/proformas?token=${proformas[0].tokenDemande}" 
                                               class="btn-action">
                                                <i class="fas fa-eye"></i>
                                                Voir les proformas
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-clipboard-list"></i>
                            <h3>Aucune demande d'achat</h3>
                            <p>Il n'y a actuellement aucune demande d'achat dans le système. Créez une nouvelle demande pour commencer le processus d'achat.</p>
                            <a href="${pageContext.request.contextPath}/achat/achat" class="btn-create">
                                <i class="fas fa-plus"></i>
                                Nouvelle demande
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <!-- NAVIGATION -->
                <div class="navigation-footer">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/achat/achat" class="nav-link-page">
                            <i class="fas fa-plus-circle"></i>
                            Nouvelle demande
                        </a>
                        <a href="${pageContext.request.contextPath}/bc/list" class="nav-link-page">
                            <i class="fas fa-list"></i>
                            Voir les bons de commande
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        // Script de recherche
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchDemandes');
            const demandesList = document.getElementById('demandesList');
            
            if (searchInput && demandesList) {
                searchInput.addEventListener('keyup', function() {
                    const searchTerm = this.value.toLowerCase();
                    const demandeCards = demandesList.querySelectorAll('.demande-card');
                    let visibleCount = 0;
                    
                    demandeCards.forEach(card => {
                        const searchText = card.getAttribute('data-search').toLowerCase();
                        
                        if (searchText.includes(searchTerm)) {
                            card.style.display = '';
                            visibleCount++;
                        } else {
                            card.style.display = 'none';
                        }
                    });
                    
                    // Afficher un message si aucun résultat
                    if (visibleCount === 0 && searchTerm) {
                        if (!document.getElementById('noResultsMessage')) {
                            const noResults = document.createElement('div');
                            noResults.id = 'noResultsMessage';
                            noResults.className = 'empty-state';
                            noResults.innerHTML = `
                                <i class="fas fa-search"></i>
                                <h3>Aucun résultat trouvé</h3>
                                <p>Aucune demande ne correspond à votre recherche : "${searchTerm}"</p>
                            `;
                            demandesList.appendChild(noResults);
                        }
                    } else {
                        const noResults = document.getElementById('noResultsMessage');
                        if (noResults) {
                            noResults.remove();
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>