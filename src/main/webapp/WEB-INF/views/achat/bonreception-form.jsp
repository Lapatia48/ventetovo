<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer Bon de Réception - Module Achat</title>
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
        .info-message { background: rgba(243,156,18,0.1); border: 1px solid rgba(243,156,18,0.2); color: var(--warning-color); padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        
        /* ===== NAVIGATION ===== */
        .navigation-header { margin-bottom: 25px; }
        .btn-back { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; background: var(--light-bg); color: var(--primary-color); text-decoration: none; border-radius: 6px; border: 1px solid var(--border-color); transition: var(--transition); }
        .btn-back:hover { background: #e9ecef; border-color: var(--secondary-color); }

        /* ===== INFO CARD ===== */
        .info-card { background: white; border-radius: 10px; box-shadow: var(--shadow); margin-bottom: 30px; overflow: hidden; }
        .card-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .card-header h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .card-header h3 i { color: var(--info-color); }
        .card-body { padding: 25px; }

        /* ===== INFO TABLE ===== */
        .info-table { width: 100%; border-collapse: collapse; }
        .info-table tr { border-bottom: 1px solid var(--border-color); }
        .info-table tr:last-child { border-bottom: none; }
        .info-table td { padding: 12px 0; vertical-align: top; }
        .info-table td:first-child { width: 200px; font-weight: 600; color: #6c757d; }
        .info-table td:last-child { color: var(--primary-color); }
        .bl-number { display: inline-block; background: var(--info-color); color: white; padding: 4px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }

        /* ===== FORM CARD ===== */
        .form-card { background: white; border-radius: 10px; box-shadow: var(--shadow); overflow: hidden; }
        .form-header { padding: 20px 25px; border-bottom: 1px solid var(--border-color); background: #f8f9fa; }
        .form-header h3 { color: var(--primary-color); font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .form-header h3 i { color: var(--success-color); }
        .form-body { padding: 25px; }

        /* ===== FORM STYLES ===== */
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 0.9rem; color: #6c757d; margin-bottom: 8px; font-weight: 500; }
        .form-input, .form-textarea, .form-select { width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.95rem; transition: var(--transition); }
        .form-input:focus, .form-textarea:focus, .form-select:focus { outline: none; border-color: var(--secondary-color); box-shadow: 0 0 0 3px rgba(52,152,219,0.1); }
        .form-textarea { min-height: 100px; resize: vertical; }
        
        /* ===== QUANTITY INPUTS ===== */
        .quantity-inputs { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .quantity-info { background: rgba(108,117,125,0.05); padding: 15px; border-radius: 6px; margin-top: 5px; font-size: 0.85rem; color: #6c757d; }
        .quantity-info strong { color: var(--primary-color); }
        
        /* ===== BUTTONS ===== */
        .form-actions { display: flex; gap: 15px; margin-top: 30px; padding-top: 25px; border-top: 1px solid var(--border-color); }
        .btn-primary, .btn-secondary { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.95rem; font-weight: 600; transition: var(--transition); display: flex; align-items: center; gap: 10px; }
        .btn-primary { background: var(--success-color); color: white; }
        .btn-primary:hover { background: #219653; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(33,150,83,0.2); }
        .btn-secondary { background: white; color: var(--primary-color); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #f8f9fa; border-color: var(--secondary-color); }
        
        /* ===== EXISTING RECEPTION ===== */
        .existing-reception { background: rgba(52,152,219,0.05); border: 1px solid rgba(52,152,219,0.2); padding: 20px; border-radius: 8px; margin-top: 25px; }
        .existing-reception p { color: var(--info-color); margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .btn-comparaison { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; background: var(--info-color); color: white; text-decoration: none; border-radius: 6px; transition: var(--transition); }
        .btn-comparaison:hover { background: #138496; transform: translateY(-2px); }

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
            .quantity-inputs { grid-template-columns: 1fr; }
            .form-actions { flex-direction: column; }
            .info-table td:first-child { width: 150px; }
        }
    </style>
    <script>
        function updateQuantiteConforme() {
            const quantiteRecue = parseInt(document.getElementById('quantiteRecue').value) || 0;
            const quantiteNonConforme = parseInt(document.getElementById('quantiteNonConforme').value) || 0;
            const quantiteConforme = quantiteRecue - quantiteNonConforme;
            
            document.getElementById('quantiteConformeDisplay').textContent = quantiteConforme;
            
            if (quantiteConforme < 0) {
                document.getElementById('quantiteConformeDisplay').style.color = 'var(--danger-color)';
            } else if (quantiteConforme < quantiteRecue) {
                document.getElementById('quantiteConformeDisplay').style.color = 'var(--warning-color)';
            } else {
                document.getElementById('quantiteConformeDisplay').style.color = 'var(--success-color)';
            }
        }
        
        function validateQuantite() {
            const quantiteRecue = parseInt(document.getElementById('quantiteRecue').value) || 0;
            const quantiteCommandee = parseInt(document.getElementById('quantiteCommandeeMax').value) || 0;
            const quantiteNonConforme = parseInt(document.getElementById('quantiteNonConforme').value) || 0;
            
            if (quantiteRecue > quantiteCommandee) {
                alert('La quantité reçue ne peut pas dépasser la quantité commandée (' + quantiteCommandee + ')');
                document.getElementById('quantiteRecue').value = quantiteCommandee;
                updateQuantiteConforme();
                return false;
            }
            
            if (quantiteNonConforme > quantiteRecue) {
                alert('La quantité non conforme ne peut pas dépasser la quantité reçue');
                document.getElementById('quantiteNonConforme').value = quantiteRecue;
                updateQuantiteConforme();
                return false;
            }
            
            return true;
        }
    </script>
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
                        <span>Bons de réception</span> / <span>Création</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <!-- NAVIGATION -->
                <div class="navigation-header">
                    <a href="${pageContext.request.contextPath}/bonLivraison/list" class="btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste
                    </a>
                </div>
                
                <!-- MESSAGES -->
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty info}">
                    <div class="info-message">
                        <i class="fas fa-info-circle"></i>
                        <span>${info}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty bonLivraison}">
                    <!-- INFORMATION CARD -->
                    <div class="info-card">
                        <div class="card-header">
                            <h3><i class="fas fa-info-circle"></i> Informations du Bon de Livraison</h3>
                        </div>
                        <div class="card-body">
                            <table class="info-table">
                                <tr>
                                    <td>Numéro livraison :</td>
                                    <td><span class="bl-number">${bonLivraison.numeroLivraison}</span></td>
                                </tr>
                                <tr>
                                    <td>Date livraison :</td>
                                    <td>${bonLivraison.dateLivraison}</td>
                                </tr>
                                <tr>
                                    <td>Transporteur :</td>
                                    <td>${bonLivraison.transporteur}</td>
                                </tr>
                                <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                                    <tr>
                                        <td>Article :</td>
                                        <td>${bonLivraison.bonCommande.proforma.article.designation}</td>
                                    </tr>
                                    <tr>
                                        <td>Quantité commandée :</td>
                                        <td><strong>${bonLivraison.bonCommande.proforma.quantite}</strong> unités</td>
                                    </tr>
                                    <tr>
                                        <td>Fournisseur :</td>
                                        <td>${bonLivraison.bonCommande.proforma.fournisseur.nom}</td>
                                    </tr>
                                </c:if>
                            </table>
                        </div>
                    </div>
                    
                    <!-- FORM CARD -->
                    <c:if test="${empty receptionExistante}">
                        <div class="form-card">
                            <div class="form-header">
                                <h3><i class="fas fa-clipboard-check"></i> Enregistrer la Réception</h3>
                            </div>
                            <div class="form-body">
                                <form action="${pageContext.request.contextPath}/bonReception/enregistrer" method="post" onsubmit="return validateQuantite()">
                                    <input type="hidden" name="idBonLivraison" value="${bonLivraison.idBonLivraison}" />
                                    
                                    <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                                        <input type="hidden" name="idArticle" value="${bonLivraison.bonCommande.proforma.idArticle}" />
                                        <input type="hidden" name="quantiteCommandee" value="${bonLivraison.bonCommande.proforma.quantite}" />
                                        <input type="hidden" id="quantiteCommandeeMax" value="${bonLivraison.bonCommande.proforma.quantite}" />
                                        
                                        <div class="quantity-inputs">
                                            <div class="form-group">
                                                <label for="quantiteRecue" class="form-label">Quantité reçue *</label>
                                                <input type="number" 
                                                       id="quantiteRecue" 
                                                       name="quantiteRecue" 
                                                       class="form-input" 
                                                       min="0" 
                                                       max="${bonLivraison.bonCommande.proforma.quantite}" 
                                                       value="${bonLivraison.bonCommande.proforma.quantite}" 
                                                       required
                                                       onchange="updateQuantiteConforme()"
                                                       onkeyup="updateQuantiteConforme()">
                                                <div class="quantity-info">
                                                    Maximum : <strong>${bonLivraison.bonCommande.proforma.quantite}</strong> unités
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="quantiteNonConforme" class="form-label">Quantité non conforme</label>
                                                <input type="number" 
                                                       id="quantiteNonConforme" 
                                                       name="quantiteNonConforme" 
                                                       class="form-input" 
                                                       min="0" 
                                                       value="0"
                                                       onchange="updateQuantiteConforme()"
                                                       onkeyup="updateQuantiteConforme()">
                                                <div class="quantity-info">
                                                    Quantité conforme : <strong id="quantiteConformeDisplay" style="color: var(--success-color);">${bonLivraison.bonCommande.proforma.quantite}</strong> unités
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="commentaire" class="form-label">Commentaire</label>
                                            <textarea id="commentaire" 
                                                      name="commentaire" 
                                                      class="form-textarea" 
                                                      rows="4" 
                                                      placeholder="Remarques éventuelles (état des marchandises, anomalies observées, etc.)"></textarea>
                                        </div>
                                        
                                        <div class="form-actions">
                                            <button type="submit" class="btn-primary">
                                                <i class="fas fa-save"></i>
                                                Enregistrer la réception
                                            </button>
                                            <a href="${pageContext.request.contextPath}/bonLivraison/detail/${bonLivraison.idBonLivraison}">
                                                <button type="button" class="btn-secondary">
                                                    <i class="fas fa-times"></i>
                                                    Annuler
                                                </button>
                                            </a>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${empty bonLivraison.bonCommande || empty bonLivraison.bonCommande.proforma}">
                                        <div class="error-message">
                                            <i class="fas fa-exclamation-circle"></i>
                                            <span>Impossible de créer le bon de réception : informations manquantes.</span>
                                        </div>
                                    </c:if>
                                </form>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- EXISTING RECEPTION -->
                    <c:if test="${not empty receptionExistante}">
                        <div class="existing-reception">
                            <p>
                                <i class="fas fa-info-circle"></i>
                                Un bon de réception existe déjà pour cette livraison.
                            </p>
                            <a href="${pageContext.request.contextPath}/bonReception/comparaison/${bonLivraison.idBonLivraison}" class="btn-comparaison">
                                <i class="fas fa-balance-scale"></i>
                                Voir la comparaison BL/BR
                            </a>
                        </div>
                    </c:if>
                </c:if>
                
                <!-- ERROR MESSAGE -->
                <c:if test="${empty bonLivraison}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Bon de livraison introuvable.</span>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
    
    <script>
        // Initialiser l'affichage de la quantité conforme
        document.addEventListener('DOMContentLoaded', function() {
            updateQuantiteConforme();
        });
    </script>
</body>
</html>