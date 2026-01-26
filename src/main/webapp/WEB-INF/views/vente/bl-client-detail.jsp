<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Bon de Livraison Client</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 900px; margin: 20px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        h1 { color: #333; margin-bottom: 20px; }
        h2 { color: #2c3e50; margin: 20px 0 10px; font-size: 18px; }
        .info-row { display: grid; grid-template-columns: 200px 1fr; padding: 10px 0; border-bottom: 1px solid #eee; }
        .info-label { font-weight: bold; color: #555; }
        .info-value { color: #333; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #333; font-weight: bold; }
        input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { display: inline-block; padding: 12px 30px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; margin-right: 10px; }
        .btn:hover { background: #2980b9; }
        .btn-success { background: #27ae60; }
        .btn-success:hover { background: #229954; }
        .btn-warning { background: #f39c12; }
        .btn-warning:hover { background: #e67e22; }
        .btn-secondary { background: #95a5a6; }
        .btn-secondary:hover { background: #7f8c8d; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Détail du Bon de Livraison Client</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="card">
            <h2>Informations du Bon de Livraison</h2>
            <div class="info-row">
                <div class="info-label">Numéro:</div>
                <div class="info-value">${bonLivraison.numeroBlClient}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date de livraison:</div>
                <div class="info-value">${bonLivraison.dateLivraison}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date prévue:</div>
                <div class="info-value">${bonLivraison.dateLivraisonPrevue}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Statut:</div>
                <div class="info-value">${bonLivraison.statut}</div>
            </div>

            <h2>Client</h2>
            <div class="info-row">
                <div class="info-label">Nom:</div>
                <div class="info-value">${client.nomComplet}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Adresse:</div>
                <div class="info-value">${client.adresse}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Téléphone:</div>
                <div class="info-value">${client.telephone}</div>
            </div>

            <h2>Article</h2>
            <div class="info-row">
                <div class="info-label">Désignation:</div>
                <div class="info-value">${article.designation}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Quantité à livrer:</div>
                <div class="info-value"><strong>${bonLivraison.quantiteLivree}</strong></div>
            </div>

            <c:if test="${not empty bonLivraison.commentaire}">
                <h2>Commentaire</h2>
                <p>${bonLivraison.commentaire}</p>
            </c:if>
        </div>

        <div style="margin-top: 20px;">
            <c:if test="${bonLivraison.statut == 'EN_PREPARATION'}">
                <form action="${pageContext.request.contextPath}/vente/bl/expedier" method="post" style="display: inline;">
                    <input type="hidden" name="idBonLivraisonClient" value="${bonLivraison.idBonLivraisonClient}">
                    <input type="hidden" name="idLivreur" value="1">
                    <button type="submit" class="btn btn-warning" onclick="return confirm('Expédier ce bon de livraison?')">
                        Expédier
                    </button>
                </form>
            </c:if>
            
            <c:if test="${bonLivraison.statut == 'EXPEDIE'}">
                <form action="${pageContext.request.contextPath}/vente/bl/livrer" method="post" style="display: inline;">
                    <input type="hidden" name="idBonLivraisonClient" value="${bonLivraison.idBonLivraisonClient}">
                    <button type="submit" class="btn btn-success" onclick="return confirm('Marquer comme livré?')">
                        Marquer comme Livré
                    </button>
                </form>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/vente/bl/list" class="btn btn-secondary">Retour à la liste</a>
        </div>
    </div>
</body>
</html>
