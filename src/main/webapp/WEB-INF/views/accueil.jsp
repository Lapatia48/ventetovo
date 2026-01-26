<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Gestion Entreprise</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: Arial, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
        }
        h1 {
            color: #333;
            margin-bottom: 40px;
            font-size: 32px;
        }
        .module-links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 900px;
        }
        .module-card {
            background: white;
            border: 2px solid #e0e0e0;
            padding: 40px 30px;
            border-radius: 10px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
        }
        .module-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            border-color: #667eea;
        }
        .module-card h2 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #667eea;
        }
        .module-card p {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestion Entreprise</h1>
        <div class="module-links">
            <a href="${pageContext.request.contextPath}/achat/achat" class="module-card">
                <h2> Module Achat</h2>
                <p>Gestion des achats, fournisseurs et approvisionnements</p>
            </a>
            <a href="${pageContext.request.contextPath}/vente/vente" class="module-card">
                <h2> Module Vente</h2>
                <p>Gestion des ventes, clients et livraisons</p>
            </a>
            <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="module-card">
                <h2> Gestion de Stock</h2>
                <p>Suivi des stocks, lots, mouvements et rapports CA</p>
            </a>
        </div>
    </div>
</body>
</html>