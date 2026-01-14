<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation Financière - Module Achat</title>
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

        /* ===== VALIDATION HEADER ===== */
        .validation-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .validation-header h2 { font-size: 1.5rem; color: var(--primary-color); font-weight: 600; }
        .proforma-number { background: var(--info-color); color: white; padding: 8px 16px; border-radius: 6px; font-weight: 600; font-size: 1.1rem; }

        /* ===== PROFORMA INFO ===== */
        .proforma-info { background: white; border-radius: 10px; box-shadow: var(--shadow); margin-bottom: 25px; padding: 25px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px; }
        .info-row { margin-bottom: 15px; }
        .info-label { font-size: 0.85rem; color: #6c757d; font-weight: 500; margin-bottom: 5px; text-transform: uppercase; }
        .info-value { font-size: 1rem; color: #333; padding: 8px 0; }

        /* ===== VALIDATION TABLE ===== */
        .validation-container { background: white; border-radius: 10px; box-shadow: var(--shadow); margin-bottom: 30px; overflow: hidden; }
        .validation-header-card { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .validation-header-card h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .validation-header-card h3 i { color: var(--info-color); }
        .validation-body { padding: 0; }
        
        .validation-table { width: 100%; border-collapse: collapse; }
        .validation-table th { padding: 18px; text-align: left; font-weight: 600; color: var(--primary-color); font-size: 0.9rem; text-transform: uppercase; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }
        .validation-table td { padding: 16px; border-bottom: 1px solid var(--border-color); }
        .validation-table tr:last-child td { border-bottom: none; }
        
        /* ===== TABLE COLORS ===== */
        .row-safe { background-color: rgba(39,174,96,0.05); }
        .row-warning { background-color: rgba(243,156,18,0.05); }
        .row-danger { background-color: rgba(231,76,60,0.05); }
        
        /* ===== AMOUNT STYLES ===== */
        .amount-normal { font-size: 1.1rem; font-weight: 500; color: var(--primary-color); }
        .amount-warning { font-size: 1.1rem; font-weight: 600; color: var(--warning-color); }
        .amount-danger { font-size: 1.1rem; font-weight: 700; color: var(--danger-color); }
        .amount-success { font-size: 1.1rem; font-weight: 700; color: var(--success-color); }
        
        /* ===== STATUS BADGES ===== */
        .status-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .status-success { background-color: rgba(39,174,96,0.15); color: var(--success-color); border: 1px solid rgba(39,174,96,0.3); }
        .status-warning { background-color: rgba(243,156,18,0.15); color: var(--warning-color); border: 1px solid rgba(243,156,18,0.3); }
        .status-danger { background-color: rgba(231,76,60,0.15); color: var(--danger-color); border: 1px solid rgba(231,76,60,0.3); }

        /* ===== MESSAGE BOXES ===== */
        .alert-warning { background: rgba(243,156,18,0.1); border: 1px solid rgba(243,156,18,0.2); color: var(--warning-color); padding: 20px; border-radius: 8px; margin: 25px 0; display: flex; align-items: flex-start; gap: 15px; }
        .alert-success { background: rgba(39,174,96,0.1); border: 1px solid rgba(39,174,96,0.2); color: var(--success-color); padding: 20px; border-radius: 8px; margin: 25px 0; display: flex; align-items: flex-start; gap: 15px; }
        .alert-icon { font-size: 1.5rem; flex-shrink: 0; }
        .alert-content { flex: 1; }
        .alert-content strong { display: block; margin-bottom: 8px; font-size: 1.1rem; }

        /* ===== VALIDATION FORM ===== */
        .validation-form { background: white; border-radius: 10px; box-shadow: var(--shadow); padding: 25px; margin-bottom: 30px; }
        .checkbox-group { margin-bottom: 25px; }
        .checkbox-label { display: flex; align-items: flex-start; gap: 12px; cursor: pointer; }
        .checkbox-input { margin-top: 3px; width: 18px; height: 18px; cursor: pointer; }
        .checkbox-text { font-size: 0.95rem; color: #333; }
        
        /* ===== ACTION BUTTONS ===== */
        .action-buttons { display: flex; gap: 15px; margin-top: 30px; }
        .btn-primary, .btn-secondary { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.95rem; font-weight: 600; transition: var(--transition); display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .btn-primary { background: var(--success-color); color: white; }
        .btn-primary:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }
        .btn-primary-danger { background: var(--danger-color); }
        .btn-primary-danger:hover { background: #c0392b; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(192,57,43,0.2); }
        .btn-secondary { background: white; color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #f8f9fa; border-color: var(--secondary-color); }

        /* ===== AUTHORIZATION INFO ===== */
        .authorization-info { background: rgba(52,152,219,0.05); border: 1px solid rgba(52,152,219,0.2); padding: 20px; border-radius: 8px; margin-top: 25px; }
        .auth-badge { display: inline-flex; align-items: center; gap: 8px; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .auth-badge-magasinier { background: rgba(39,174,96,0.15); color: var(--success-color); }
        .auth-badge-valideur { background: rgba(243,156,18,0.15); color: var(--warning-color); }

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
            .validation-header { flex-direction: column; align-items: flex-start; gap: 15px; }
            .action-buttons { flex-direction: column; }
            .nav-links { flex-direction: column; gap: 10px; }
            .info-grid { grid-template-columns: 1fr; }
            .validation-table { display: block; overflow-x: auto; }
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
                        <span>Validation</span> / <span>Financière</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <c:choose>
                    <c:when test="${empty proforma}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <h3>Erreur : Proforma introuvable</h3>
                            <div style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/achat/achat" class="btn-secondary">
                                    <i class="fas fa-home"></i>
                                    Retour à l'accueil
                                </a>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- HEADER -->
                        <div class="validation-header">
                            <h2>Validation Financière</h2>
                            <div class="proforma-number">
                                ${proforma.numero}
                            </div>
                        </div>
                        
                        <!-- PROFORMA INFO -->
                        <div class="proforma-info">
                            <div class="info-grid">
                                <div class="info-row">
                                    <span class="info-label">Proforma</span>
                                    <span class="info-value"><strong>${proforma.numero}</strong></span>
                                </div>
                                
                                <c:if test="${not empty proforma.article}">
                                    <div class="info-row">
                                        <span class="info-label">Article</span>
                                        <span class="info-value">${proforma.article.designation}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty proforma.fournisseur}">
                                    <div class="info-row">
                                        <span class="info-label">Fournisseur</span>
                                        <span class="info-value">${proforma.fournisseur.nom}</span>
                                    </div>
                                </c:if>
                                
                                <div class="info-row">
                                    <span class="info-label">Quantité</span>
                                    <span class="info-value">${proforma.quantite} unités</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- VALIDATION TABLE -->
                        <div class="validation-container">
                            <div class="validation-header-card">
                                <h3><i class="fas fa-balance-scale"></i> Analyse Financière</h3>
                            </div>
                            <div class="validation-body">
                                <table class="validation-table">
                                    <thead>
                                        <tr>
                                            <th>Description</th>
                                            <th>Montant (Ar)</th>
                                            <th>Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Montant Proforma</td>
                                            <td class="amount-normal">${montantProforma}</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>Seuil d'approbation</td>
                                            <td class="amount-normal">${montantSeuil}</td>
                                            <td></td>
                                        </tr>
                                        <tr class="${ecart > 0 ? 'row-danger' : 'row-safe'}">
                                            <td>Écart (Proforma - Seuil)</td>
                                            <td class="${ecart > 0 ? 'amount-danger' : 'amount-success'}">${ecart}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ecart > 0}">
                                                        <span class="status-badge status-danger">
                                                            Dépasse le seuil
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-success">
                                                            Inférieur au seuil
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- ALERT MESSAGE -->
                        <c:choose>
                            <c:when test="${ecart > 0}">
                                <div class="alert-warning">
                                    <i class="fas fa-exclamation-triangle alert-icon"></i>
                                    <div class="alert-content">
                                        <strong>Attention : Validation supplémentaire requise</strong>
                                        <p>Cette proforma dépasse le seuil d'approbation de <strong>${ecart} Ar</strong>. 
                                           Une validation de niveau supérieur est nécessaire pour procéder.</p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert-success">
                                    <i class="fas fa-check-circle alert-icon"></i>
                                    <div class="alert-content">
                                        <strong>Proforma conforme aux critères</strong>
                                        <p>Cette proforma est inférieure au seuil d'approbation. 
                                           Vous pouvez valider sans approbation supplémentaire.</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- AUTHORIZATION INFO -->
                        <div class="authorization-info">
                            <div class="info-row">
                                <span class="info-label">Autorisation requise</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${ecart > 0}">
                                            <span class="auth-badge auth-badge-valideur">
                                                <i class="fas fa-user-shield"></i>
                                                Valideur Niveau 1
                                            </span>
                                            <p style="margin-top: 8px; color: #6c757d; font-size: 0.9rem;">
                                                Seul le valideur N1 (valideur1@vente.com) peut approuver ce montant.
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="auth-badge auth-badge-magasinier">
                                                <i class="fas fa-user-tie"></i>
                                                Magasinier
                                            </span>
                                            <p style="margin-top: 8px; color: #6c757d; font-size: 0.9rem;">
                                                Le magasinier (magasinier@vente.com) peut valider ce montant.
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <!-- VALIDATION FORM -->
                        <div class="validation-form">
                            <form action="${pageContext.request.contextPath}/achat/validerProforma" method="post">
                                <input type="hidden" name="idProforma" value="${idProforma}">
                                <input type="hidden" name="tokenDemande" value="${tokenDemande}">
                                
                                <!-- Input hidden selon le seuil -->
                                <c:choose>
                                    <c:when test="${ecart <= 0}">
                                        <!-- Seuil non dépassé : magasinier peut valider -->
                                        <input type="hidden" name="emailAutorise" value="magasinier@vente.com">
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Seuil dépassé : seulement valideur N1 peut valider -->
                                        <input type="hidden" name="emailAutorise" value="valideur1@vente.com">
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="checkbox-group">
                                    <label class="checkbox-label">
                                        <input type="checkbox" id="confirmation" name="confirmation" value="oui" required class="checkbox-input">
                                        <span class="checkbox-text">
                                            Je confirme vouloir valider cette proforma et atteste que toutes les informations sont correctes.
                                            Je comprends que cette action est irréversible.
                                        </span>
                                    </label>
                                </div>
                                
                                <div class="action-buttons">
                                    <button type="submit" class="btn-primary ${ecart > 0 ? 'btn-primary-danger' : ''}">
                                        <i class="fas fa-check-circle"></i>
                                        <c:choose>
                                            <c:when test="${ecart > 0}">
                                                Valider (Dépassement - Valideur N1 requis)
                                            </c:when>
                                            <c:otherwise>
                                                Valider (Magasinier)
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                    
                                    <a href="${pageContext.request.contextPath}/achat/proformas?token=${tokenDemande}" 
                                       class="btn-secondary">
                                        <i class="fas fa-arrow-left"></i>
                                        Retour aux proformas
                                    </a>
                                </div>
                            </form>
                        </div>
                        
                        <!-- NAVIGATION -->
                        <div class="navigation-footer">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/achat/proformas?token=${tokenDemande}" class="nav-link-page">
                                    <i class="fas fa-list"></i>
                                    Liste des proformas
                                </a>
                                <a href="${pageContext.request.contextPath}/achat/demandes" class="nav-link-page">
                                    <i class="fas fa-clipboard-list"></i>
                                    Toutes les demandes
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