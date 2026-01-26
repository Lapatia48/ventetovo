<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail Proforma Client</title>
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
        .btn { display: inline-block; padding: 12px 30px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; margin-right: 10px; }
        .btn:hover { background: #2980b9; }
        .btn-success { background: #27ae60; }
        .btn-success:hover { background: #229954; }
        .btn-danger { background: #e74c3c; }
        .btn-danger:hover { background: #c0392b; }
        .btn-secondary { background: #95a5a6; }
        .btn-secondary:hover { background: #7f8c8d; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .alert-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge { display: inline-block; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-warning { background: #f39c12; color: white; }
        .badge-success { background: #27ae60; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Détail du Proforma Client</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="card">
            <h2>Informations du Proforma</h2>
            <div class="info-row">
                <div class="info-label">Numéro:</div>
                <div class="info-value">${proforma.numeroProforma}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date:</div>
                <div class="info-value">${proforma.dateProforma}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Date de validité:</div>
                <div class="info-value">${proforma.dateValidite}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Statut:</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${proforma.statut == 'EN_ATTENTE'}">
                            <span class="badge badge-warning">EN ATTENTE</span>
                        </c:when>
                        <c:when test="${proforma.statut == 'ACCEPTE'}">
                            <span class="badge badge-success">ACCEPTÉ</span>
                        </c:when>
                        <c:otherwise>
                            ${proforma.statut}
                        </c:otherwise>
                    </c:choose>
                </div>
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
                <div class="info-label">Code:</div>
                <div class="info-value">${article.codeArticle}</div>
            </div>
            <div class="info-row">
                <div class="info-label">Quantité:</div>
                <div class="info-value">${proforma.quantite}</div>
            </div>

            <h2>Tarification</h2>
            <div class="info-row">
                <div class="info-label">Prix unitaire:</div>
                <div class="info-value">${proforma.prixUnitaire} Ar</div>
            </div>
            <c:if test="${not empty proforma.montantReduction && proforma.montantReduction > 0}">
                <div class="info-row">
                    <div class="info-label">Réduction:</div>
                    <div class="info-value">-${proforma.montantReduction} Ar</div>
                </div>
            </c:if>
            <div class="info-row">
                <div class="info-label">Montant total:</div>
                <div class="info-value"><strong>${proforma.montantTotal} Ar</strong></div>
            </div>

            <c:if test="${not empty stock}">
                <h2>Stock disponible</h2>
                <div class="info-row">
                    <div class="info-label">Disponible:</div>
                    <div class="info-value">
                        ${stockDisponible} unités
                        <c:if test="${stockDisponible < proforma.quantite}">
                            <div class="alert-warning" style="display: inline; margin-left: 10px;">Stock insuffisant!</div>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>

        <div style="margin-top: 20px;">
            <c:if test="${proforma.statut == 'EN_ATTENTE' && stockDisponible >= proforma.quantite}">
                <form action="${pageContext.request.contextPath}/vente/proforma/accepter" method="post" style="display: inline;">
                    <input type="hidden" name="idProformaClient" value="${proforma.idProformaClient}">
                    <button type="submit" class="btn btn-success" onclick="return confirm('Accepter ce proforma?')">Accepter</button>
                </form>
            </c:if>
            <a href="${pageContext.request.contextPath}/vente/proforma/list" class="btn btn-secondary">Retour à la liste</a>
        </div>
    </div>
</body>
</html>
