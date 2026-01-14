<%-- achat/facturefournisseur-detail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détail Facture</title>
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
        .statut-reglee { background-color: #d4edda; color: #155724; }
        .statut-en_retard { background-color: #f8d7da; color: #721c24; }
        .statut-annulee { background-color: #e9ecef; color: #495057; }
        .btn-action { 
            padding: 8px 16px;
            margin: 5px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-regler { background-color: #28a745; color: white; border: none; cursor: pointer; }
        .btn-retour { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
    <h2>🧾 Détail Facture #${facture.numeroFacture}</h2>
    
    <c:if test="${empty facture}">
        <p style="color: red;">Facture introuvable.</p>
    </c:if>
    
    <c:if test="${not empty facture}">
        <div class="detail-box">
            <div class="info-row">
                <span class="label">Numéro facture:</span>
                <span class="value"><strong>${facture.numeroFacture}</strong></span>
            </div>
            
            <div class="info-row">
                <span class="label">Bon de commande:</span>
                <span class="value">
                    <a href="${pageContext.request.contextPath}/bc/detail/${facture.idBonCommande}">
                        BC #${facture.idBonCommande}
                    </a>
                </span>
            </div>
            
            <div class="info-row">
                <span class="label">Date facture:</span>
                <span class="value">${facture.dateFacture}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Échéance:</span>
                <span class="value">
                    ${facture.dateEcheance}
                    <c:if test="${facture.statut == 'EN_RETARD'}">
                        <span style="color: #dc3545; font-weight: bold;"> (EN RETARD)</span>
                    </c:if>
                </span>
            </div>
            
            <div class="info-row">
                <span class="label">Montant total:</span>
                <span class="value" style="font-size: 1.2em; font-weight: bold;">
                    ${facture.montantTotal} Ar
                </span>
            </div>
            
            <div class="info-row">
                <span class="label">Statut:</span>
                <span class="value statut-badge statut-${facture.statut.toLowerCase()}">
                    ${facture.statut}
                </span>
            </div>
            
            <c:if test="${not empty facture.bonCommande}">
                <hr>
                <h3>📦 Informations Bon de Commande</h3>
                <div class="info-row">
                    <span class="label">Date commande:</span>
                    <span class="value">${facture.bonCommande.dateCommande}</span>
                </div>
                
                <c:if test="${not empty facture.bonCommande.proforma}">
                    <div class="info-row">
                        <span class="label">Article:</span>
                        <span class="value">
                            <c:if test="${not empty facture.bonCommande.proforma.article}">
                                ${facture.bonCommande.proforma.article.designation}
                            </c:if>
                        </span>
                    </div>
                    
                    <div class="info-row">
                        <span class="label">Fournisseur:</span>
                        <span class="value">
                            <c:if test="${not empty facture.bonCommande.proforma.fournisseur}">
                                ${facture.bonCommande.proforma.fournisseur.nom}
                            </c:if>
                        </span>
                    </div>
                </c:if>
            </c:if>
        </div>
        
        <div style="margin-top: 20px;">
            <c:if test="${facture.statut == 'EN_ATTENTE'}">
                <form action="${pageContext.request.contextPath}/factureFournisseur/regler" method="post" style="display: inline;">
                    <input type="hidden" name="idFacture" value="${facture.idFacture}">
                    <button type="submit" class="btn-action btn-regler">
                        Receptionner
                    </button>
                </form>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/factureFournisseur/list" class="btn-action btn-retour">
                ← Retour à la liste
            </a>
        </div>
    </c:if>
</body>
</html>