<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détail Bon de Commande</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .detail-box { 
            border: 1px solid #ccc; 
            padding: 20px; 
            margin: 20px 0;
            border-radius: 5px;
        }
        .info-row { margin: 10px 0; }
        .label { font-weight: bold; color: #555; width: 200px; display: inline-block; }
        .value { color: #333; }
        .statut-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
        }
        .statut-en-cours { background-color: #fff3cd; color: #856404; }
        .statut-livre { background-color: #d4edda; color: #155724; }
        .statut-annule { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h2> Détail du Bon de Commande #${bonCommande.idBonCommande}</h2>
    
    <c:if test="${empty bonCommande}">
        <p style="color: red;">Bon de commande introuvable.</p>
    </c:if>
    
    <c:if test="${not empty bonCommande}">
        <div class="detail-box">
            <div class="info-row">
                <span class="label">N° Bon de Commande:</span>
                <span class="value">${bonCommande.idBonCommande}</span>
            </div>
            
            <div class="info-row">
                <span class="label">N° Proforma:</span>
                <span class="value">${bonCommande.numeroProforma}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Date de commande:</span>
                <span class="value">${bonCommande.dateCommande}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Statut:</span>
                <span class="value statut-badge statut-${bonCommande.statut.toLowerCase()}">
                    ${bonCommande.statut}
                </span>
            </div>
            
            <div class="info-row">
                <span class="label">Token demande:</span>
                <span class="value">${bonCommande.tokenDemande}</span>
            </div>
            
            <hr>
            
            <h3> Informations Article</h3>
            <div class="info-row">
                <span class="label">Code article:</span>
                <span class="value">${bonCommande.codeArticle}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Désignation:</span>
                <span class="value">${bonCommande.designationArticle}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Quantité:</span>
                <span class="value">${bonCommande.quantite}</span>
            </div>
            
            <hr>
            
            <h3> Informations Fournisseur</h3>
            <div class="info-row">
                <span class="label">Fournisseur:</span>
                <span class="value">${bonCommande.nomFournisseur}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Email:</span>
                <span class="value">${bonCommande.emailFournisseur}</span>
            </div>
            
            <div class="info-row">
                <span class="label">Téléphone:</span>
                <span class="value">${bonCommande.telephoneFournisseur}</span>
            </div>
            
            <hr>
            
            <h3> Informations Financières</h3>
            <div class="info-row">
                <span class="label">Prix unitaire:</span>
                <span class="value">${bonCommande.prixUnitaire} Ar</span>
            </div>
            
            <div class="info-row">
                <span class="label">Montant total:</span>
                <span class="value"><strong>${bonCommande.montantTotal} Ar</strong></span>
            </div>
        </div>
        
        <form action="${pageContext.request.contextPath}/genererFactureFournisseur" method="post">
            <input type="hidden" name="idBonCommande" value="${bonCommande.idBonCommande}">
            <button type="submit">Générer facture fournisseur</button>
        </form>
        
        <br>
        <a href="${pageContext.request.contextPath}/bc/list"> Retour à la liste</a>
        &nbsp;&nbsp;
        <a href="${pageContext.request.contextPath}/achat/achat"> Accueil</a>
    </c:if>
</body>
</html>