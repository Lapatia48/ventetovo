<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Module Vente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .header {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            color: #f5576c;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-info {
            text-align: right;
        }
        .user-name {
            font-weight: 600;
            color: #333;
        }
        .logout-btn {
            display: inline-block;
            margin-top: 8px;
            padding: 8px 20px;
            background: #f5576c;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .logout-btn:hover {
            background: #f093fb;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #f5576c;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-value {
            font-size: 36px;
            font-weight: 700;
            color: #f5576c;
            margin-bottom: 8px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
            transition: all 0.3s;
            display: block;
        }
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .menu-icon {
            font-size: 40px;
            color: #f5576c;
            margin-bottom: 15px;
        }
        .menu-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .menu-description {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        h2 {
            color: white;
            margin: 30px 0 20px;
            font-size: 24px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-chart-line"></i>
                Dashboard Module Vente
            </h1>
            <div class="user-info">
                <div class="user-name">${utilisateur.nomUtilisateur}</div>
                <a href="${pageContext.request.contextPath}/user/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Déconnexion
                </a>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${nbClients}</div>
                <div class="stat-label">Clients</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbDevis}</div>
                <div class="stat-label">Devis</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbCommandes}</div>
                <div class="stat-label">Commandes Clients</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbLivraisons}</div>
                <div class="stat-label">Livraisons</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbFactures}</div>
                <div class="stat-label">Factures</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${chiffreAffaires} Ar</div>
                <div class="stat-label">Chiffre d'Affaires</div>
            </div>
        </div>

        <!-- Menu Fonctionnalités -->
        <h2>Fonctionnalités du Module</h2>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/vente/articles" class="menu-card">
                <div class="menu-icon"><i class="fas fa-box-open"></i></div>
                <div class="menu-title">Catalogue Articles</div>
                <div class="menu-description">Consulter les articles disponibles à la vente</div>
            </a>

            <a href="${pageContext.request.contextPath}/vente/devis" class="menu-card">
                <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
                <div class="menu-title">Gestion Devis</div>
                <div class="menu-description">Créer et gérer les devis clients</div>
            </a>

            <a href="${pageContext.request.contextPath}/vente/commandes" class="menu-card">
                <div class="menu-icon"><i class="fas fa-shopping-bag"></i></div>
                <div class="menu-title">Commandes Clients</div>
                <div class="menu-description">Gérer les commandes clients</div>
            </a>

            <a href="${pageContext.request.contextPath}/vente/livraisons" class="menu-card">
                <div class="menu-icon"><i class="fas fa-truck-loading"></i></div>
                <div class="menu-title">Livraisons</div>
                <div class="menu-description">Gérer les livraisons aux clients</div>
            </a>

            <a href="${pageContext.request.contextPath}/vente/factures" class="menu-card">
                <div class="menu-icon"><i class="fas fa-receipt"></i></div>
                <div class="menu-title">Factures Clients</div>
                <div class="menu-description">Créer et gérer les factures</div>
            </a>

            <a href="${pageContext.request.contextPath}/vente/commandes/a-valider" class="menu-card">
                <div class="menu-icon"><i class="fas fa-check-circle"></i></div>
                <div class="menu-title">Validation Commandes</div>
                <div class="menu-description">Valider les commandes en attente</div>
            </a>
        </div>
    </div>
</body>
</html>
