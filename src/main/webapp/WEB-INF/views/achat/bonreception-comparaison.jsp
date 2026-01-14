<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comparaison BL/BR - Module Achat</title>
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

        /* ===== MESSAGES ===== */
        .error-message { background: rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.2); color: var(--danger-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .warning-message { background: rgba(243,156,18,0.1); border: 1px solid rgba(243,156,18,0.2); color: var(--warning-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .success-message { background: rgba(39,174,96,0.1); border: 1px solid rgba(39,174,96,0.2); color: var(--success-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }

        /* ===== COMPARISON TABLE ===== */
        .comparison-container { background: white; border-radius: 10px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 25px; }
        .comparison-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .comparison-header h2 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .comparison-header h2 i { color: var(--info-color); }
        .comparison-body { padding: 0; }

        /* ===== COMPARISON TABLE ===== */
        .comparison-table { width: 100%; border-collapse: collapse; }
        .comparison-table thead th { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 18px; text-align: center; font-weight: 600; color: var(--primary-color); font-size: 1rem; }
        .comparison-table tbody td { padding: 16px; border-bottom: 1px solid var(--border-color); text-align: center; }
        .comparison-table .section-header { background: rgba(0,0,0,0.02); font-weight: 600; color: var(--primary-color); font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .comparison-table .info-label { color: #6c757d; font-size: 0.9rem; }
        
        /* ===== QUANTITY STYLES ===== */
        .quantity-perfect { color: var(--success-color); font-weight: 700; font-size: 1.3rem; }
        .quantity-warning { color: var(--warning-color); font-weight: 700; font-size: 1.3rem; }
        .quantity-error { color: var(--danger-color); font-weight: 700; font-size: 1.3rem; }

        /* ===== COLORS ===== */
        .bl-column { background: rgba(52,152,219,0.05); }
        .br-column { background: rgba(39,174,96,0.05); }
        .center-column { background: rgba(108,117,125,0.05); }

        /* ===== VALIDATION SECTION ===== */
        .validation-container { background: white; border-radius: 10px; box-shadow: var(--shadow); padding: 25px; margin-bottom: 25px; }
        .validation-container h3 { color: var(--primary-color); margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .validation-container h3 i { color: var(--success-color); }

        /* ===== BUTTONS ===== */
        .btn-primary, .btn-secondary { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.95rem; font-weight: 600; transition: var(--transition); display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .btn-primary { background: var(--success-color); color: white; }
        .btn-primary:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }
        .btn-secondary { background: white; color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #f8f9fa; border-color: var(--secondary-color); }

        /* ===== NOTE ===== */
        .note-box { background: rgba(108,117,125,0.05); border-left: 4px solid #6c757d; padding: 15px; border-radius: 6px; margin-top: 20px; }
        .note-box em { color: #6c757d; font-size: 0.9rem; }

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
            .comparison-table { display: block; overflow-x: auto; }
            .nav-links { flex-direction: column; gap: 10px; }
            .comparison-table thead th, 
            .comparison-table tbody td { padding: 12px; }
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
                        <span>Comparaison</span> / <span>BL vs BR</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <!-- NAVIGATION -->
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/bonLivraison/list" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste
                    </a>
                </div>
                
                <!-- ERROR MESSAGE -->
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty bonLivraison && not empty bonReception}">
                    <!-- STATUS MESSAGES -->
                    <c:if test="${correspondanceParfaite}">
                        <div class="success-message">
                            <i class="fas fa-check-circle"></i>
                            <span><strong>Correspondance parfaite :</strong> Toutes les quantités correspondent.</span>
                        </div>
                    </c:if>
                    
                    <c:if test="${not correspondanceParfaite}">
                        <div class="warning-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span><strong>Attention :</strong> Des écarts ont été détectés entre la livraison et la réception.</span>
                        </div>
                    </c:if>
                    
                    <!-- COMPARISON TABLE -->
                    <div class="comparison-container">
                        <div class="comparison-header">
                            <h2><i class="fas fa-balance-scale"></i> Comparaison Bon de Livraison / Bon de Réception</h2>
                        </div>
                        <div class="comparison-body">
                            <table class="comparison-table">
                                <thead>
                                    <tr>
                                        <th class="bl-column">Bon de Livraison</th>
                                        <th class="center-column">Critère</th>
                                        <th class="br-column">Bon de Réception</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="bl-column">
                                            <strong>${bonLivraison.numeroLivraison}</strong>
                                        </td>
                                        <td class="center-column info-label">
                                            <strong>Numéro</strong>
                                        </td>
                                        <td class="br-column">
                                            <strong>BR-${bonReception.idBonReception}</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bl-column">${bonLivraison.dateLivraison}</td>
                                        <td class="center-column info-label"><strong>Date</strong></td>
                                        <td class="br-column">${bonReception.dateReception}</td>
                                    </tr>
                                    
                                    <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                                        <!-- INFORMATIONS ARTICLE -->
                                        <tr>
                                            <td colspan="3" class="section-header">
                                                <i class="fas fa-box"></i> INFORMATIONS ARTICLE
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" style="text-align: center; padding: 20px;">
                                                <div style="font-size: 1.1rem; color: var(--primary-color);">
                                                    ${bonLivraison.bonCommande.proforma.article.designation}
                                                </div>
                                                <div style="color: #6c757d; margin-top: 5px;">
                                                    Code: ${bonLivraison.bonCommande.proforma.article.code}
                                                </div>
                                            </td>
                                        </tr>
                                        
                                        <!-- QUANTITIES -->
                                        <tr>
                                            <td class="bl-column" style="padding: 20px;">
                                                <div class="quantity-perfect">${bonLivraison.bonCommande.proforma.quantite}</div>
                                            </td>
                                            <td class="center-column info-label" style="padding: 20px;">
                                                <strong>Quantité commandée</strong>
                                            </td>
                                            <td class="br-column" style="padding: 20px;">
                                                <div class="quantity-perfect">${bonReception.quantiteCommandee}</div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bl-column">-</td>
                                            <td class="center-column info-label"><strong>Quantité reçue</strong></td>
                                            <td class="br-column">
                                                <div class="${bonReception.quantiteRecue == bonReception.quantiteCommandee ? 'quantity-perfect' : 'quantity-warning'}">
                                                    ${bonReception.quantiteRecue}
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bl-column">-</td>
                                            <td class="center-column info-label"><strong>Quantité conforme</strong></td>
                                            <td class="br-column">
                                                <div class="quantity-perfect">${bonReception.quantiteConforme}</div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bl-column">-</td>
                                            <td class="center-column info-label"><strong>Quantité non conforme</strong></td>
                                            <td class="br-column">
                                                <div class="${bonReception.quantiteNonConforme > 0 ? 'quantity-error' : 'quantity-perfect'}">
                                                    ${bonReception.quantiteNonConforme}
                                                </div>
                                            </td>
                                        </tr>
                                        
                                        <!-- COMMENTAIRE -->
                                        <c:if test="${not empty bonReception.commentaire}">
                                            <tr>
                                                <td class="bl-column">-</td>
                                                <td class="center-column info-label"><strong>Commentaire</strong></td>
                                                <td class="br-column" style="text-align: left; padding: 15px;">
                                                    <div style="background: rgba(108,117,125,0.05); padding: 10px; border-radius: 6px;">
                                                        ${bonReception.commentaire}
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                        
                                        <!-- INFORMATIONS FOURNISSEUR -->
                                        <tr>
                                            <td colspan="3" class="section-header">
                                                <i class="fas fa-truck"></i> INFORMATIONS FOURNISSEUR
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" style="text-align: center; padding: 15px;">
                                                <div style="font-size: 1.1rem; color: var(--primary-color);">
                                                    ${bonLivraison.bonCommande.proforma.fournisseur.nom}
                                                </div>
                                                <c:if test="${not empty bonLivraison.bonCommande.proforma.fournisseur.email}">
                                                    <div style="color: #6c757d; margin-top: 5px;">
                                                        ${bonLivraison.bonCommande.proforma.fournisseur.email}
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bl-column">${bonLivraison.transporteur}</td>
                                            <td class="center-column info-label"><strong>Transporteur</strong></td>
                                            <td class="br-column">-</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- VALIDATION SECTION -->
                    <div class="validation-container">
                        <h3><i class="fas fa-clipboard-check"></i> Validation de la réception</h3>
                        
                        <c:if test="${bonLivraison.statut != 'RECU'}">
                            <form action="${pageContext.request.contextPath}/bonReception/valider" method="post" 
                                  onsubmit="return confirm('Êtes-vous sûr de vouloir valider cette réception ? Cette action est irréversible.');">
                                <input type="hidden" name="idBonLivraison" value="${bonLivraison.idBonLivraison}" />
                                <input type="hidden" name="idBonReception" value="${bonReception.idBonReception}" />
                                
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-check-circle"></i>
                                    Valider la réception et mettre à jour le stock
                                </button>
                                
                                <div class="note-box">
                                    <em>
                                        <strong>Note :</strong> Cette action marquera le bon de livraison comme reçu et déclenchera 
                                        la mise à jour du stock et du mouvement de caisse.
                                    </em>
                                </div>
                            </form>
                        </c:if>
                        
                        <c:if test="${bonLivraison.statut == 'RECU'}">
                            <div class="success-message" style="margin: 0;">
                                <i class="fas fa-check-circle"></i>
                                <span>Cette réception a déjà été validée.</span>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                
                <c:if test="${empty bonLivraison || empty bonReception}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Données manquantes pour effectuer la comparaison.</span>
                    </div>
                </c:if>
                
                <!-- NAVIGATION FOOTER -->
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
            </div>
        </main>
    </div>
</body>
</html>