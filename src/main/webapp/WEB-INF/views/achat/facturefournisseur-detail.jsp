<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Facture - Module Achat</title>
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

        /* ===== ERROR MESSAGE ===== */
        .error-message { background: rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.2); color: var(--danger-color); padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0; }
        .error-message i { font-size: 2rem; margin-bottom: 10px; }

        /* ===== DETAIL HEADER ===== */
        .detail-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .detail-header h2 { font-size: 1.5rem; color: var(--primary-color); font-weight: 600; }
        .facture-number { background: linear-gradient(135deg, #6f42c1 0%, #6610f2 100%); color: white; padding: 8px 16px; border-radius: 6px; font-weight: 600; font-size: 1.1rem; }

        /* ===== DETAIL CARDS ===== */
        .detail-card { background: white; border-radius: 10px; box-shadow: var(--shadow); margin-bottom: 25px; overflow: hidden; }
        .card-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .card-header h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .card-header h3 i { color: var(--secondary-color); }
        .card-body { padding: 25px; }

        /* ===== INFO GRID ===== */
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .info-row { margin-bottom: 15px; }
        .info-label { font-size: 0.85rem; color: #6c757d; font-weight: 500; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { font-size: 1rem; color: #333; padding: 8px 0; }

        /* ===== STATUS BADGES ===== */
        .statut-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .statut-en_attente { background-color: rgba(243,156,18,0.15); color: var(--warning-color); border: 1px solid rgba(243,156,18,0.3); }
        .statut-reglee { background-color: rgba(39,174,96,0.15); color: var(--success-color); border: 1px solid rgba(39,174,96,0.3); }
        .statut-en_retard { background-color: rgba(231,76,60,0.15); color: var(--danger-color); border: 1px solid rgba(231,76,60,0.3); }
        .statut-annulee { background-color: rgba(108,117,125,0.15); color: #6c757d; border: 1px solid rgba(108,117,125,0.3); }

        /* ===== FINANCIAL HIGHLIGHTS ===== */
        .financial-highlight { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-left: 4px solid var(--success-color); padding: 25px; border-radius: 8px; margin-top: 20px; }
        .amount-large { font-size: 1.8rem; font-weight: 700; color: var(--success-color); }
        .amount-medium { font-size: 1.2rem; font-weight: 600; color: var(--primary-color); }
        .currency { font-size: 0.9rem; color: #6c757d; margin-left: 5px; }
        
        /* ===== WARNING BADGE ===== */
        .warning-badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(231,76,60,0.1); color: var(--danger-color); padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; margin-left: 10px; }
        .warning-badge i { font-size: 0.7rem; }

        /* ===== ACTION BUTTONS ===== */
        .action-buttons { display: flex; gap: 15px; margin-top: 30px; padding-top: 25px; border-top: 1px solid var(--border-color); }
        .btn-primary, .btn-secondary { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.95rem; font-weight: 600; transition: var(--transition); display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .btn-primary { background: var(--success-color); color: white; }
        .btn-primary:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }
        .btn-secondary { background: white; color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #f8f9fa; border-color: var(--secondary-color); }

        /* ===== PROFORMA DETAILS ===== */
        .proforma-details { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 20px; border-radius: 8px; margin-top: 20px; }
        .proforma-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
        
        /* ===== SUPPLIER INFO ===== */
        .supplier-info { background: rgba(52,152,219,0.05); border: 1px solid rgba(52,152,219,0.2); padding: 20px; border-radius: 8px; margin-top: 20px; }
        .supplier-contact { display: flex; gap: 20px; margin-top: 10px; }
        .supplier-contact-item { display: flex; align-items: center; gap: 8px; color: #6c757d; font-size: 0.9rem; }

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
            .supplier-contact { flex-direction: column; gap: 10px; }
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
                        <span>Factures fournisseurs</span> / <span>Détail</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <c:choose>
                    <c:when test="${empty facture}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <h3>Facture introuvable</h3>
                            <div style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="btn-secondary">
                                    <i class="fas fa-arrow-left"></i>
                                    Retour à la liste
                                </a>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="detail-header">
                            <h2>Détail Facture</h2>
                            <div class="facture-number">
                                #${facture.numeroFacture}
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
                                        <span class="info-label">Numéro facture</span>
                                        <span class="info-value"><strong>${facture.numeroFacture}</strong></span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Bon de commande</span>
                                        <span class="info-value">
                                            <a href="${pageContext.request.contextPath}/bc/detail/${facture.idBonCommande}" 
                                               style="color: var(--secondary-color); text-decoration: none; font-weight: 500;">
                                                <i class="fas fa-file-contract"></i>
                                                BC #${facture.idBonCommande}
                                            </a>
                                        </span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Date facture</span>
                                        <span class="info-value">${facture.dateFacture}</span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Échéance</span>
                                        <span class="info-value">
                                            ${facture.dateEcheance}
                                            <c:if test="${facture.statut == 'EN_RETARD'}">
                                                <span class="warning-badge">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    EN RETARD
                                                </span>
                                            </c:if>
                                        </span>
                                    </div>
                                    
                                    <div class="info-row">
                                        <span class="info-label">Statut</span>
                                        <span class="info-value">
                                            <span class="statut-badge statut-${facture.statut.toLowerCase()}">
                                                ${facture.statut}
                                            </span>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- MONTANT -->
                                <div class="financial-highlight">
                                    <div class="info-row">
                                        <span class="info-label">Montant total</span>
                                        <span class="amount-large">${facture.montantTotal} <span class="currency">Ar</span></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- INFORMATIONS BON DE COMMANDE -->
                        <c:if test="${not empty facture.bonCommande}">
                            <div class="detail-card">
                                <div class="card-header">
                                    <h3><i class="fas fa-file-contract"></i> Informations Bon de Commande</h3>
                                </div>
                                <div class="card-body">
                                    <div class="info-grid">
                                        <div class="info-row">
                                            <span class="info-label">Date commande</span>
                                            <span class="info-value">${facture.bonCommande.dateCommande}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- DETAILS DU PROFORMA -->
                        <c:if test="${not empty facture.bonCommande && not empty facture.bonCommande.proforma}">
                            <div class="detail-card">
                                <div class="card-header">
                                    <h3><i class="fas fa-file-invoice"></i> Détails du Proforma</h3>
                                </div>
                                <div class="card-body">
                                    <div class="proforma-details">
                                        <div class="info-grid">
                                            <div class="info-row">
                                                <span class="info-label">Numéro proforma</span>
                                                <span class="info-value">${facture.bonCommande.proforma.numero}</span>
                                            </div>
                                            
                                            <div class="info-row">
                                                <span class="info-label">Date proforma</span>
                                                <span class="info-value">${facture.bonCommande.proforma.dateProforma}</span>
                                            </div>
                                        </div>
                                        
                                        <!-- ARTICLE -->
                                        <div class="info-row" style="margin-top: 20px;">
                                            <span class="info-label">Article</span>
                                            <span class="info-value">
                                                <c:if test="${not empty facture.bonCommande.proforma.article}">
                                                    <div style="font-weight: 600; color: var(--primary-color);">
                                                        ${facture.bonCommande.proforma.article.designation}
                                                    </div>
                                                    <div style="color: #6c757d; margin-top: 5px;">
                                                        Code: ${facture.bonCommande.proforma.article.code}
                                                    </div>
                                                </c:if>
                                            </span>
                                        </div>
                                        
                                        <!-- QUANTITE ET PRIX -->
                                        <div class="proforma-grid" style="margin-top: 20px;">
                                            <div class="info-row">
                                                <span class="info-label">Quantité</span>
                                                <span class="info-value" style="font-size: 1.2rem; font-weight: 600;">
                                                    ${facture.bonCommande.proforma.quantite} unités
                                                </span>
                                            </div>
                                            
                                            <div class="info-row">
                                                <span class="info-label">Prix unitaire</span>
                                                <span class="info-value" style="font-size: 1.1rem;">
                                                    ${facture.bonCommande.proforma.prixUnitaire} <span class="currency">Ar</span>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <!-- MONTANT PROFORMA -->
                                        <div style="margin-top: 20px;">
                                            <div class="info-row">
                                                <span class="info-label">Montant total proforma</span>
                                                <span class="amount-medium">${facture.bonCommande.proforma.montantTotal} <span class="currency">Ar</span></span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- FOURNISSEUR -->
                                    <c:if test="${not empty facture.bonCommande.proforma.fournisseur}">
                                        <div class="supplier-info" style="margin-top: 25px;">
                                            <div class="info-row">
                                                <span class="info-label">Fournisseur</span>
                                                <span class="info-value">
                                                    <strong style="color: var(--primary-color); font-size: 1.1rem;">
                                                        ${facture.bonCommande.proforma.fournisseur.nom}
                                                    </strong>
                                                </span>
                                            </div>
                                            
                                            <div class="supplier-contact">
                                                <c:if test="${not empty facture.bonCommande.proforma.fournisseur.email}">
                                                    <div class="supplier-contact-item">
                                                        <i class="fas fa-envelope"></i>
                                                        ${facture.bonCommande.proforma.fournisseur.email}
                                                    </div>
                                                </c:if>
                                                
                                                <c:if test="${not empty facture.bonCommande.proforma.fournisseur.telephone}">
                                                    <div class="supplier-contact-item">
                                                        <i class="fas fa-phone"></i>
                                                        ${facture.bonCommande.proforma.fournisseur.telephone}
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- ACTIONS -->
                        <div class="action-buttons">
                            <c:if test="${facture.statut == 'EN_ATTENTE'}">
                                <form action="${pageContext.request.contextPath}/factureFournisseur/regler" method="post" style="display: inline;">
                                    <input type="hidden" name="idFacture" value="${facture.idFacture}">
                                    <button type="submit" class="btn-primary">
                                        <i class="fas fa-check-circle"></i>
                                        Régler la facture
                                    </button>
                                </form>
                            </c:if>
                            
                            <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Retour à la liste
                            </a>
                            <a href="${pageContext.request.contextPath}/bc/list" class="btn-secondary">
                                <i class="fas fa-file-contract"></i>
                                Bons de commande
                            </a>
                        </div>
                        
                        <!-- NAVIGATION -->
                        <div class="navigation-footer">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="nav-link-page">
                                    <i class="fas fa-list"></i>
                                    Liste des factures
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