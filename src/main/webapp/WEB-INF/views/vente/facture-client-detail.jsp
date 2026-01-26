<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Facture Client</title>
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
        .btn-secondary { background: #95a5a6; }
        .btn-secondary:hover { background: #7f8c8d; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Détail de la Facture Client</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="card">
            <h2>Informations de la Facture</h2>
            <div class="info-row">
                <div class="info-label">Numéro:</div>
                <div class="info-value">${facture.numeroFactureClient}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date:</div>
                <div class="info-value">${facture.dateFacture}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date d'échéance:</div>
                <div class="info-value">${facture.dateEcheance}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Statut:</div>
                <div class="info-value">${facture.statutPaiement}</div>
            </div>

            <h2>Client</h2>
            <div class="info-row">
                <div class="info-label">Nom:</div>
                <div class="info-value">${client.nomComplet}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Email:</div>
                <div class="info-value">${client.email}</div>
            </div>

            <h2>Article</h2>
            <div class="info-row">
                <div class="info-label">Désignation:</div>
                <div class="info-value">${article.designation}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Quantité:</div>
                <div class="info-value">${bonCommande.quantite}</div>
            </div>

            <h2>Montants</h2>
            <div class="info-row">
                <div class="info-label">Montant total:</div>
                <div class="info-value"><strong>${facture.montantTotal} Ar</strong></div>
            </div>
            <div class="info-row">
                <div class="info-label">Montant payé:</div>
                <div class="info-value">${facture.montantPaye} Ar</div>
            </div>
            <div class="info-row">
                <div class="info-label">Montant restant:</div>
                <div class="info-value"><strong>${facture.montantTotal - facture.montantPaye} Ar</strong></div>
            </div>
        </div>

        <c:if test="${facture.statutPaiement != 'PAYE'}">
            <div class="card">
                <h2>Enregistrer un Paiement</h2>
                <form action="${pageContext.request.contextPath}/vente/facture/payer" method="post">
                    <input type="hidden" name="idFactureClient" value="${facture.idFactureClient}">
                    
                    <div class="form-group">
                        <label for="montantPaye">Montant du paiement (Ar) *</label>
                        <input type="number" id="montantPaye" name="montantPaye" 
                               step="0.01" min="0.01" max="${facture.montantTotal - facture.montantPaye}" 
                               value="${facture.montantTotal - facture.montantPaye}" required>
                    </div>

                    <button type="submit" class="btn btn-success">Enregistrer le Paiement</button>
                </form>
            </div>
        </c:if>

        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/vente/facture/list" class="btn btn-secondary">Retour à la liste</a>
        </div>
    </div>
</body>
</html>
