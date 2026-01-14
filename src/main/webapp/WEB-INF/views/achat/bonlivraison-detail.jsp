<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Bon de Livraison - Module Achat</title>
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

        /* ===== SIDEBAR STYLES (COHERENT) ===== */
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
        
        /* ===== DETAIL HEADER ===== */
        .detail-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .detail-header h2 { font-size: 1.5rem; color: var(--primary-color); font-weight: 600; }
        .bl-number { background: var(--info-color); color: white; padding: 8px 16px; border-radius: 6px; font-weight: 600; font-size: 1.1rem; }

        /* ===== ERROR MESSAGE ===== */
        .error-message { background: rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.2); color: var(--danger-color); padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0; }
        .error-message i { font-size: 2rem; margin-bottom: 10px; }

        /* ===== DETAIL CARD ===== */
        .detail-card { background: white; border-radius: 10px; box-shadow: var(--shadow); margin-bottom: 20px; overflow: hidden; }
        .card-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .card-header h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .card-header h3 i { color: var(--info-color); }
        .card-body { padding: 25px; }
        
        /* ===== INFO GRID ===== */
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .info-row { margin-bottom: 15px; }
        .info-label { font-size: 0.85rem; color: #6c757d; font-weight: 500; margin-bottom: 5px; text-transform: uppercase; }
        .info-value { font-size: 1rem; color: #333; padding: 8px 0; }

        /* ===== STATUS BADGES ===== */
        .statut-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; }
        .statut-en_attente { background-color: rgba(243,156,18,0.15); color: var(--warning-color); border: 1px solid rgba(243,156,18,0.3); }
        .statut-recu { background-color: rgba(39,174,96,0.15); color: var(--success-color); border: 1px solid rgba(39,174,96,0.3); }
        .statut-partiel { background-color: rgba(52,152,219,0.15); color: var(--secondary-color); border: 1px solid rgba(52,152,219,0.3); }
        .statut-annule { background-color: rgba(231,76,60,0.15); color: var(--danger-color); border: 1px solid rgba(231,76,60,0.3); }

        /* ===== RECEPTION FORM ===== */
        .reception-form { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-left: 4px solid var(--success-color); padding: 25px; border-radius: 8px; margin: 25px 0; }
        .reception-form h3 { color: var(--primary-color); margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .reception-form p { color: #6c757d; margin-bottom: 20px; }

        /* ===== ACTION BUTTONS ===== */
        .action-buttons { display: flex; gap: 15px; margin-top: 20px; }
        .btn-primary, .btn-secondary { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.95rem; font-weight: 600; transition: var(--transition); display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .btn-primary { background: var(--success-color); color: white; }
        .btn-primary:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }
        .btn-secondary { background: white; color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #f8f9fa; border-color: var(--secondary-color); }

        /* ===== SUCCESS MESSAGE ===== */
        .success-message { background: rgba(39,174,96,0.1); border: 1px solid rgba(39,174,96,0.2); color: var(--success-color); padding: 20px; border-radius: 8px; margin: 25px 0; display: flex; align-items: center; gap: 15px; }
        .success-message i { font-size: 1.5rem; }

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
            .detail-header { flex-direction: column; align-items: flex-start; gap: 15px; }
            .info-grid { grid-template-columns: 1fr; }
            .action-buttons { flex-direction: column; }
            .nav-links { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- SIDEBAR COHERENTE -->
       <%@ include file="../achat/sidebar.jsp" %> 
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <header class="main-header">
                <div class="header-content">
                    <h1 class="page-title">Module d'Achat</h1>
                    <div class="breadcrumb">
                        <span>Bons de livraison</span> / <span>Détail</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <c:choose>
                    <c:when test="${empty bonLivraison}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <h3>Bon de livraison introuvable</h3>
                            <div style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/bonLivraison/list" class="btn-secondary">
                                    <i class="fas fa-arrow-left"></i>
                                    Retour à la liste
                                </a>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="detail-header">
                            <h2>Détail du Bon de Livraison</h2>
                            <div class="bl-number">
                                #${bonLivraison.numeroLivraison}
                            </div>
                        </div>
                        
                        <!-- INFORMATIONS PRINCIPALES -->
                        <div class="detail-card">
                            <div class="card-header">
                                <h3><i class="fas fa-info-circle"></i> Informations principales</h3>
                            </div>
                            <div class="card-body">
                                <div class="info-grid">
                                    <div class="info-row">
                                        <span class="info-label">Numéro livraison</span>
                                        <span class="info-value"><strong>${bonLivraison.numeroLivraison}</strong></span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Bon de commande</span>
                                        <span class="info-value">
                                            <a href="${pageContext.request.contextPath}/bc/detail/${bonLivraison.idBonCommande}" 
                                               style="color: var(--secondary-color); text-decoration: none; font-weight: 500;">
                                                <i class="fas fa-file-contract"></i>
                                                BC #${bonLivraison.idBonCommande}
                                            </a>
                                        </span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Date livraison</span>
                                        <span class="info-value">${bonLivraison.dateLivraison}</span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Transporteur</span>
                                        <span class="info-value">${bonLivraison.transporteur}</span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">N° bon transport</span>
                                        <span class="info-value">${bonLivraison.numeroBonTransport}</span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Statut</span>
                                        <span class="info-value">
                                            <span class="statut-badge statut-${bonLivraison.statut.toLowerCase()}">
                                                ${bonLivraison.statut}
                                            </span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- INFORMATIONS COMMANDE -->
                        <c:if test="${not empty bonLivraison.bonCommande}">
                            <div class="detail-card">
                                <div class="card-header">
                                    <h3><i class="fas fa-box"></i> Informations de la commande</h3>
                                </div>
                                <div class="card-body">
                                    <div class="info-grid">
                                        <div class="info-row">
                                            <span class="info-label">Date commande</span>
                                            <span class="info-value">${bonLivraison.bonCommande.dateCommande}</span>
                                        </div>
                                        
                                        <c:if test="${not empty bonLivraison.bonCommande.proforma}">
                                            <div class="info-row">
                                                <span class="info-label">Article</span>
                                                <span class="info-value">
                                                    <c:if test="${not empty bonLivraison.bonCommande.proforma.article}">
                                                        ${bonLivraison.bonCommande.proforma.article.designation}
                                                    </c:if>
                                                </span>
                                            </div>
                                            
                                            <div class="info-row">
                                                <span class="info-label">Quantité</span>
                                                <span class="info-value">
                                                    ${bonLivraison.bonCommande.proforma.quantite} unités
                                                </span>
                                            </div>
                                            
                                            <div class="info-row">
                                                <span class="info-label">Fournisseur</span>
                                                <span class="info-value">
                                                    <c:if test="${not empty bonLivraison.bonCommande.proforma.fournisseur}">
                                                        ${bonLivraison.bonCommande.proforma.fournisseur.nom}
                                                    </c:if>
                                                </span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- FORMULAIRE DE RECEPTION -->
                        <c:if test="${bonLivraison.statut == 'EN_ATTENTE'}">
                            <div class="reception-form">
                                <h3><i class="fas fa-clipboard-check"></i> Créer un Bon de Réception</h3>
                                <p>Pour enregistrer la réception de cette livraison, cliquez sur le bouton ci-dessous :</p>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/bonReception/form/${bonLivraison.idBonLivraison}" 
                                       class="btn-primary">
                                        <i class="fas fa-clipboard-check"></i>
                                        Créer un bon de réception
                                    </a>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- MESSAGE RECEPTION -->
                        <c:if test="${bonLivraison.statut == 'RECU'}">
                            <div class="success-message">
                                <i class="fas fa-check-circle"></i>
                                <div>
                                    <strong>Cette livraison a été réceptionnée</strong>
                                    <p style="margin-top: 5px; margin-bottom: 0;">La réception a été enregistrée dans le système.</p>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- ACTIONS -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/bonLivraison/list" class="btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Retour à la liste
                            </a>
                            <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="btn-secondary">
                                <i class="fas fa-file-invoice"></i>
                                Factures
                            </a>
                        </div>
                        
                        <!-- NAVIGATION -->
                        <div class="navigation-footer">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/bonLivraison/list" class="nav-link-page">
                                    <i class="fas fa-list"></i>
                                    Liste des livraisons
                                </a>
                                <a href="${pageContext.request.contextPath}/achat/achat" class="nav-link-page">
                                    <i class="fas fa-home"></i>
                                    Menu achat
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>