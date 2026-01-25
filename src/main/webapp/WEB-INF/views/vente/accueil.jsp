<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Module Vente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .menu {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 30px 0;
        }
        .menu a {
            display: inline-block;
            padding: 15px 30px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .menu a:hover {
            background: #0056b3;
        }
        .user-info {
            text-align: center;
            margin-bottom: 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty utilisateur}">
                    Bienvenue, <strong>${empty utilisateur.nom ? '' : utilisateur.nom} ${empty utilisateur.prenom ? '' : utilisateur.prenom}</strong> (Module Vente)
                </c:when>
                <c:otherwise>
                    Bienvenue (Module Vente)
                </c:otherwise>
            </c:choose>
        </div>
        
        <h1>Module Vente - Gestion Commerciale</h1>
        
        <div class="menu">
            <a href="${pageContext.request.contextPath}/vente/articles">Liste Articles → Créer Devis</a>
             <a href="${pageContext.request.contextPath}/vente/devis">Gestion Devis</a> 
            <a href="${pageContext.request.contextPath}/vente/commandes">Gestion Commandes</a>
            <a href="${pageContext.request.contextPath}/vente/livraisons">Gestion Livraisons</a>
            <a href="${pageContext.request.contextPath}/vente/commandes/a-valider">Validation Commandes</a>
            <a href="${pageContext.request.contextPath}/vente/factures">Gestion Factures</a>
            <a href="${pageContext.request.contextPath}/vente/factures">Toutes les factures</a>
            <a href="${pageContext.request.contextPath}/vente/factures/validees">Factures validées</a>
            <a href="${pageContext.request.contextPath}/vente/factures/a-encaisser">Factures à encaisser</a>
            <a href="${pageContext.request.contextPath}/vente/reglements">Historique règlements</a>
            <a href="${pageContext.request.contextPath}/vente/factures/payees">Factures payées</a>

            <!-- <a href="${pageContext.request.contextPath}/vente/clients">Gestion Clients</a> -->
        </div>
        
        
        <div style="text-align: center; color: #888; margin-top: 20px; font-size: 0.9em;">
            <p><em>Note: Les autres modules sont en cours de développement</em></p>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/user/logout" style="color: #dc3545;">Déconnexion</a>
        </div>
    </div>
</body>
</html>