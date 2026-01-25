<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Module Achat</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #667eea;
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
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .logout-btn:hover {
            background: #764ba2;
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
            border-left: 4px solid #667eea;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-value {
            font-size: 36px;
            font-weight: 700;
            color: #667eea;
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
            color: #667eea;
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
                <i class="fas fa-shopping-cart"></i>
                Dashboard Module Achat
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
                <div class="stat-value">${nbDemandes}</div>
                <div class="stat-label">Demandes d'Achat</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbProformas}</div>
                <div class="stat-label">Proformas Reçus</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbBonCommandes}</div>
                <div class="stat-label">Bons de Commande</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${montantTotal} Ar</div>
                <div class="stat-label">Montant Total BC</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbBonLivraisons}</div>
                <div class="stat-label">Bons de Livraison</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${nbFactures}</div>
                <div class="stat-label">Factures Fournisseurs</div>
            </div>
        </div>

        <!-- Menu Fonctionnalités -->
        <h2>Fonctionnalités du Module</h2>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/achat/achat" class="menu-card">
                <div class="menu-icon"><i class="fas fa-box"></i></div>
                <div class="menu-title">Gestion Articles</div>
                <div class="menu-description">Gérer le catalogue des articles et les prix d'achat</div>
            </a>

            <a href="${pageContext.request.contextPath}/achat/demandes" class="menu-card">
                <div class="menu-icon"><i class="fas fa-file-invoice"></i></div>
                <div class="menu-title">Demandes d'Achat</div>
                <div class="menu-description">Consulter et gérer les demandes d'achat</div>
            </a>

            <a href="${pageContext.request.contextPath}/bc/list" class="menu-card">
                <div class="menu-icon"><i class="fas fa-receipt"></i></div>
                <div class="menu-title">Bons de Commande</div>
                <div class="menu-description">Créer et valider les bons de commande</div>
            </a>

            <a href="${pageContext.request.contextPath}/bonLivraison/list" class="menu-card">
                <div class="menu-icon"><i class="fas fa-truck"></i></div>
                <div class="menu-title">Bons de Livraison</div>
                <div class="menu-description">Gérer les livraisons fournisseurs</div>
            </a>

            <a href="${pageContext.request.contextPath}/bonReception/form/1" class="menu-card">
                <div class="menu-icon"><i class="fas fa-clipboard-check"></i></div>
                <div class="menu-title">Réception Marchandises</div>
                <div class="menu-description">Valider la réception des marchandises</div>
            </a>

            <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="menu-card">
                <div class="menu-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <div class="menu-title">Factures Fournisseurs</div>
                <div class="menu-description">Gérer les factures des fournisseurs</div>
            </a>
        </div>
    </div>
</body>
</html>
