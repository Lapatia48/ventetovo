<%-- achat/bonlivraison-detail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détail Bon de Livraison</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .detail-box { 
            border: 1px solid #ccc; 
            padding: 20px; 
            margin: 20px 0;
            border-radius: 5px;
            max-width: 800px;
        }
        .info-row { margin: 10px 0; }
        .label { font-weight: bold; color: #555; width: 200px; display: inline-block; }
        .value { color: #333; }
        .statut-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
        }
        .statut-en_attente { background-color: #fff3cd; color: #856404; }
        .statut-recu { background-color: #d4edda; color: #155724; }
        .statut-partiel { background-color: #cce5ff; color: #004085; }
        .statut-annule { background-color: #f8d7da; color: #721c24; }
        .btn-action { 
            padding: 8px 16px;
            margin: 5px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-receptionner { background-color: #28a745; color: white; border: none; cursor: pointer; }
        .btn-retour { background-color: #6c757d; color: white; }
        .reception-form {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h2>🚚 Détail Bon de Livraison #${bonLivraison.numeroLivraison}</h2>
    
    <c:if test="${empty bonLivraison}">
        <p style="color: red;">Bon de livraison introuvable.</p>
    </c:if>
    
    <c:if test="${not empty bonLivraison}">
        <div class="detail-box">
            <div class="info-row">
                <span class="label">Numéro livraison:</span>
                <span class="value"><strong>${bonLivraison.numeroLivraison}</strong></span>
            </div>
            
            <div class="info-row">
                <span class="label">Bon de commande:</span>
                <span class="value">
                    <a href="${pageContext.request.contextPath}/bc/detail/${bonLivraison.idBonCommande}">
                        BC #${bonLivraison.idBonCommande}
                    </a>
                </span>
            </div>
            
            <div class="info-row">
                <span class="label">Date livraison:</span>
                <span class="value">${bonLivraison.dateLivraison}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Transporteur:</span>
                <span class="value">${bonLivraison.transporteur}</span>
            </div>
            
            <div class="info-row">
                <span class="label">N° bon transport:</span>
                <span class="value">${bonLivraison.numeroBonTransport}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Statut:</span>
                <span class="value statut-badge statut-${bonLivraison.statut.toLowerCase()}">
                    ${bonLivraison.statut}
                </span>
            </div>
            
            <c:if test="${not empty bonLivraison.bonCommande}">
                <hr>
                <h3>📦 Informations de la commande</h3>
                <div class="info-row">
                    <span class="label">Date commande:</span>
                    <span class="value">${bonLivraison.bonCommande.dateCommande}</span>
                </div>
                
                <c:if test="${not empty bonLivraison.bonCommande.proforma}">
                    <div class="info-row">
                        <span class="label">Article:</span>
                        <span class="value">
                            <c:if test="${not empty bonLivraison.bonCommande.proforma.article}">
                                ${bonLivraison.bonCommande.proforma.article.designation}
                            </c:if>
                        </span>
                    </div>
                    
                    <div class="info-row">
                        <span class="label">Quantité:</span>
                        <span class="value">
                            ${bonLivraison.bonCommande.proforma.quantite}
                        </span>
                    </div>
                    
                    <div class="info-row">
                        <span class="label">Fournisseur:</span>
                        <span class="value">
                            <c:if test="${not empty bonLivraison.bonCommande.proforma.fournisseur}">
                                ${bonLivraison.bonCommande.proforma.fournisseur.nom}
                            </c:if>
                        </span>
                    </div>
                </c:if>
            </c:if>
        </div>
        
        <!-- Formulaire de réception -->
        <c:if test="${bonLivraison.statut == 'EN_ATTENTE'}">
            <div class="reception-form">
                <h3> Réception de la livraison</h3>
                <form action="${pageContext.request.contextPath}/bonLivraison/receptionner" method="post">
                    <input type="hidden" name="idBonLivraison" value="${bonLivraison.idBonLivraison}">
                    
                    <div style="margin: 10px 0;">
                        <label>Quantité reçue:</label>
                        <input type="number" name="quantiteRecue" required 
                               value="${bonLivraison.bonCommande.proforma.quantite}"
                               min="0" max="${bonLivraison.bonCommande.proforma.quantite}">
                    </div>
                    
                    <div style="margin: 10px 0;">
                        <label>Quantité non conforme:</label>
                        <input type="number" name="quantiteNonConforme" value="0" min="0">
                    </div>
                    
                    <div style="margin: 10px 0;">
                        <label>Commentaire:</label><br>
                        <textarea name="commentaire" rows="3" style="width: 300px;"></textarea>
                    </div>
                    
                    <button type="submit" class="btn-action btn-receptionner">
                         Enregistrer la réception
                    </button>
                </form>
            </div>
        </c:if>
        
        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/bonLivraison/list" class="btn-action btn-retour">
                ← Retour à la liste
            </a>
        </div>
    </c:if>
</body>
</html>