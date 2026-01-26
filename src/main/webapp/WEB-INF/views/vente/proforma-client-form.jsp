<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un Proforma Client</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 800px; margin: 20px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; margin-bottom: 20px; }
        .info-box { background: #e8f4f8; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #333; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .btn { display: inline-block; padding: 12px 30px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; font-size: 16px; }
        .btn:hover { background: #2980b9; }
        .btn-secondary { background: #95a5a6; }
        .btn-secondary:hover { background: #7f8c8d; }
        .stock-warning { background: #fff3cd; color: #856404; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .stock-ok { background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h1>Créer un Proforma Client</h1>

            <div class="info-box">
                <h3>Article: ${article.designation}</h3>
                <p><strong>Code:</strong> ${article.codeArticle}</p>
                <p><strong>Catégorie:</strong> ${article.categorie}</p>
            </div>

            <c:if test="${not empty stock}">
                <c:choose>
                    <c:when test="${stockDisponible > 0}">
                        <div class="stock-ok">
                            <strong>Stock disponible:</strong> ${stockDisponible} unités
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="stock-warning">
                            <strong>Attention:</strong> Stock insuffisant (${stockDisponible} unités disponibles)
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <form action="${pageContext.request.contextPath}/vente/proforma/creer" method="post">
                <input type="hidden" name="idArticle" value="${idArticle}">

                <div class="form-group">
                    <label for="idClient">Client *</label>
                    <select id="idClient" name="idClient" required>
                        <option value="">-- Sélectionner un client --</option>
                        <c:forEach var="client" items="${clients}">
                            <option value="${client.idClient}">${client.nomComplet} (${client.email})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="quantite">Quantité *</label>
                    <input type="number" id="quantite" name="quantite" min="1" 
                           max="${stockDisponible}" required>
                </div>

                <div class="form-group">
                    <label for="codeReduction">Code de réduction (optionnel)</label>
                    <select id="codeReduction" name="codeReduction">
                        <option value="">-- Aucune réduction --</option>
                        <c:forEach var="reduction" items="${reductions}">
                            <option value="${reduction.codeReduction}">
                                ${reduction.codeReduction} - ${reduction.description} 
                                <c:choose>
                                    <c:when test="${reduction.typeReduction == 'POURCENTAGE'}">(${reduction.valeur}%)</c:when>
                                    <c:otherwise>(${reduction.valeur} Ar)</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-top: 30px;">
                    <button type="submit" class="btn">Créer le proforma</button>
                    <a href="${pageContext.request.contextPath}/vente/vente" class="btn btn-secondary">Annuler</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
