<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demande de quantité - Module Achat</title>
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
        .content-wrapper { padding: 30px; flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; }

        /* ===== QUANTITY CARD ===== */
        .quantity-card { 
            background: white; 
            border-radius: 12px; 
            box-shadow: var(--shadow); 
            padding: 40px; 
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }
        
        .quantity-header { 
            text-align: center; 
            margin-bottom: 30px; 
            padding-bottom: 20px; 
            border-bottom: 1px solid var(--border-color); 
        }
        
        .quantity-header h2 { 
            color: var(--primary-color); 
            font-size: 1.5rem; 
            margin-bottom: 10px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            gap: 10px; 
        }
        
        .quantity-header h2 i { 
            color: var(--info-color); 
        }
        
        .article-info { 
            color: #6c757d; 
            font-size: 0.95rem; 
            margin-top: 10px; 
        }
        
        /* ===== QUANTITY FORM ===== */
        .quantity-form { 
            margin-top: 20px; 
        }
        
        .form-group { 
            margin-bottom: 30px; 
        }
        
        .form-label { 
            display: block; 
            font-size: 1rem; 
            color: var(--primary-color); 
            margin-bottom: 12px; 
            font-weight: 600; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        
        .form-label i { 
            color: var(--secondary-color); 
        }
        
        .form-input { 
            width: 100%; 
            padding: 14px 16px; 
            border: 2px solid var(--border-color); 
            border-radius: 8px; 
            font-size: 1.1rem; 
            transition: var(--transition); 
            font-weight: 500; 
            text-align: center; 
        }
        
        .form-input:focus { 
            outline: none; 
            border-color: var(--secondary-color); 
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1); 
        }
        
        .quantity-hint { 
            margin-top: 8px; 
            font-size: 0.85rem; 
            color: #6c757d; 
            text-align: center; 
        }
        
        /* ===== ACTION BUTTONS ===== */
        .action-buttons { 
            display: flex; 
            gap: 15px; 
            margin-top: 30px; 
        }
        
        .btn-primary, .btn-secondary { 
            flex: 1; 
            padding: 14px; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 1rem; 
            font-weight: 600; 
            transition: var(--transition); 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            gap: 10px; 
        }
        
        .btn-primary { 
            background: var(--success-color); 
            color: white; 
        }
        
        .btn-primary:hover { 
            background: #219653; 
            transform: translateY(-2px); 
            box-shadow: 0 4px 12px rgba(33,150,83,0.2); 
        }
        
        .btn-secondary { 
            background: white; 
            color: var(--primary-color); 
            border: 2px solid var(--border-color); 
        }
        
        .btn-secondary:hover { 
            background: #f8f9fa; 
            border-color: var(--secondary-color); 
        }
        
        /* ===== STEP INDICATOR ===== */
        .step-indicator { 
            display: flex; 
            justify-content: center; 
            gap: 40px; 
            margin-bottom: 40px; 
            max-width: 500px; 
            width: 100%; 
        }
        
        .step { 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            gap: 8px; 
        }
        
        .step-number { 
            width: 36px; 
            height: 36px; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 600; 
            font-size: 1rem; 
            transition: var(--transition); 
        }
        
        .step-active .step-number { 
            background: var(--secondary-color); 
            color: white; 
            box-shadow: 0 0 0 4px rgba(52,152,219,0.2); 
        }
        
        .step-inactive .step-number { 
            background: #e9ecef; 
            color: #6c757d; 
        }
        
        .step-completed .step-number { 
            background: var(--success-color); 
            color: white; 
        }
        
        .step-label { 
            font-size: 0.85rem; 
            color: #6c757d; 
            font-weight: 500; 
        }
        
        .step-active .step-label { 
            color: var(--secondary-color); 
            font-weight: 600; 
        }
        
        .step-completed .step-label { 
            color: var(--success-color); 
        }
        
        .step-line { 
            flex: 1; 
            height: 2px; 
            background: #e9ecef; 
            margin-top: 18px; 
        }
        
        /* ===== INFO CARD ===== */
        .info-card { 
            background: rgba(52,152,219,0.05); 
            border: 1px solid rgba(52,152,219,0.2); 
            border-radius: 8px; 
            padding: 20px; 
            margin-top: 25px; 
            width: 100%; 
            max-width: 500px; 
        }
        
        .info-card h4 { 
            color: var(--secondary-color); 
            margin-bottom: 10px; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        
        .info-card p { 
            color: #6c757d; 
            font-size: 0.9rem; 
            line-height: 1.5; 
        }
        
        /* ===== NAVIGATION ===== */
        .navigation-footer { 
            margin-top: 40px; 
            padding-top: 20px; 
            border-top: 1px solid var(--border-color); 
            width: 100%; 
            max-width: 500px; 
        }
        
        .nav-links { 
            display: flex; 
            justify-content: center; 
            gap: 20px; 
        }
        
        .nav-link-page { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            color: var(--secondary-color); 
            text-decoration: none; 
            font-weight: 500; 
            transition: var(--transition); 
        }
        
        .nav-link-page:hover { 
            color: #2980b9; 
            gap: 12px; 
        }
        
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
            .quantity-card { padding: 30px 20px; }
            .action-buttons { flex-direction: column; }
            .step-indicator { gap: 20px; }
            .step-line { display: none; }
            .nav-links { flex-direction: column; align-items: center; gap: 10px; }
        }
        
        @media (max-width: 480px) {
            .quantity-card { padding: 25px 15px; }
            .form-input { padding: 12px 14px; font-size: 1rem; }
            .btn-primary, .btn-secondary { padding: 12px; }
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
                        <span>Nouvelle demande</span> / <span>Quantité</span>
                    </div>
                </div>
            </header>
            
            <div class="content-wrapper">
                <!-- STEP INDICATOR -->
                <div class="step-indicator">
                    <div class="step step-completed">
                        <div class="step-number">1</div>
                        <div class="step-label">Article</div>
                    </div>
                    <div class="step-line"></div>
                    <div class="step step-active">
                        <div class="step-number">2</div>
                        <div class="step-label">Quantité</div>
                    </div>
                    <div class="step-line"></div>
                    <div class="step step-inactive">
                        <div class="step-number">3</div>
                        <div class="step-label">Proformas</div>
                    </div>
                </div>
                
                <!-- QUANTITY CARD -->
                <div class="quantity-card">
                    <div class="quantity-header">
                        <h2>
                            <i class="fas fa-balance-scale"></i>
                            Spécifier la quantité
                        </h2>
                        <div class="article-info">
                            Article sélectionné: <strong>#${idArticle}</strong>
                        </div>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/achat/quantite" method="post" class="quantity-form">
                        <input type="hidden" name="idArticle" value="${idArticle}">
                        
                        <div class="form-group">
                            <label for="quantite" class="form-label">
                                <i class="fas fa-boxes"></i>
                                Quantité requise
                            </label>
                            <input type="number" 
                                   id="quantite" 
                                   name="quantite" 
                                   min="1" 
                                   max="10000" 
                                   required 
                                   class="form-input"
                                   placeholder="Entrez la quantité souhaitée">
                            <div class="quantity-hint">
                                Quantité minimale: 1 unité
                            </div>
                        </div>
                        
                        <div class="action-buttons">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-check-circle"></i>
                                Valider la quantité
                            </button>
                            
                            <a href="${pageContext.request.contextPath}/achat/achat" class="btn-secondary">
                                <i class="fas fa-times"></i>
                                Annuler
                            </a>
                        </div>
                    </form>
                </div>
                
                <!-- INFO CARD -->
                <div class="info-card">
                    <h4><i class="fas fa-info-circle"></i> Information importante</h4>
                    <p>
                        Cette quantité servira à générer une demande d'achat qui sera envoyée aux fournisseurs.
                        Assurez-vous de spécifier la quantité exacte dont vous avez besoin pour éviter toute erreur dans le processus d'achat.
                    </p>
                </div>
                
                <!-- NAVIGATION -->
                <div class="navigation-footer">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/achat/achat" class="nav-link-page">
                            <i class="fas fa-arrow-left"></i>
                            Retour à la liste des articles
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const quantityInput = document.getElementById('quantite');
            
            // Focus sur le champ de quantité au chargement
            if (quantityInput) {
                quantityInput.focus();
                
                // Validation en temps réel
                quantityInput.addEventListener('input', function() {
                    const value = parseInt(this.value);
                    
                    if (value < 1) {
                        this.setCustomValidity('La quantité doit être au moins de 1 unité');
                    } else if (value > 10000) {
                        this.setCustomValidity('La quantité ne peut pas dépasser 10 000 unités');
                    } else {
                        this.setCustomValidity('');
                    }
                });
                
                // Ajouter une classe pour le style quand on interagit
                quantityInput.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                quantityInput.addEventListener('blur', function() {
                    this.parentElement.classList.remove('focused');
                });
            }
            
            // Confirmation avant de soumettre
            const form = document.querySelector('.quantity-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const quantity = parseInt(quantityInput.value);
                    if (quantity < 1 || quantity > 10000) {
                        e.preventDefault();
                        alert('Veuillez entrer une quantité valide entre 1 et 10 000 unités.');
                        quantityInput.focus();
                    }
                });
            }
        });
    </script>
</body>
</html>