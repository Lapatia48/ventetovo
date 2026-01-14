<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Comparaison BL/BR</title>
</head>
<body>
    <h2>🔍 Comparaison Bon de Livraison / Bon de Réception</h2>
    
    <p><a href="${pageContext.request.contextPath}/bonLivraison/list">← Retour à la liste</a></p>
    
    <c:if test="${not empty error}">
        <p style="color: red; font-weight: bold;">${error}</p>
    </c:if>
    
    <c:if test="${not empty bonLivraison && not empty bonReception}">
        
        <c:if test="${correspondanceParfaite}">
            <div style="background-color: #d4edda; border: 1px solid #c3e6cb; padding: 15px; margin-bottom: 20px;">
                <strong>✅ Correspondance parfaite:</strong> Toutes les quantités correspondent.
            </div>
        </c:if>
        
        <c:if test="${not correspondanceParfaite}">
            <div style="background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; margin-bottom: 20px;">
                <strong>⚠️ Attention:</strong> Des écarts ont été détectés entre la livraison et la réception.
            </div>
        </c:if>
        
        <table border="1" style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #f0f0f0;">
                    <th style="width: 40%;">Bon de Livraison</th>
                    <th style="width: 20%; text-align: center;">Critère</th>
                    <th style="width: 40%;">Bon de Réception</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>${bonLivraison.numeroLivraison}</td>
                    <td style="text-align: center;"><strong>Numéro</strong></td>
                    <td>BR-${bonReception.idBonReception}</td>
                </tr>
                <tr>
                    <td>${bonLivraison.dateLivraison}</td>
                    <td style="text-align: center;"><strong>Date</strong></td>
                    <td>${bonReception.dateReception}</td>
                </tr>
                
                <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                    <tr>
                        <td colspan="3" style="background-color: #e9ecef; font-weight: bold; text-align: center;">
                            INFORMATIONS ARTICLE
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: center;">
                            ${bonLivraison.bonCommande.proforma.article.designation}
                            (Code: ${bonLivraison.bonCommande.proforma.article.code})
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 1.2em;">
                            <strong>${bonLivraison.bonCommande.proforma.quantite}</strong>
                        </td>
                        <td style="text-align: center;"><strong>Quantité commandée</strong></td>
                        <td style="text-align: center; font-size: 1.2em;">
                            <strong>${bonReception.quantiteCommandee}</strong>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">-</td>
                        <td style="text-align: center;"><strong>Quantité reçue</strong></td>
                        <td style="text-align: center; font-size: 1.2em;">
                            <strong style="color: ${bonReception.quantiteRecue == bonReception.quantiteCommandee ? 'green' : 'orange'};">
                                ${bonReception.quantiteRecue}
                            </strong>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">-</td>
                        <td style="text-align: center;"><strong>Quantité conforme</strong></td>
                        <td style="text-align: center; font-size: 1.2em;">
                            <strong style="color: green;">
                                ${bonReception.quantiteConforme}
                            </strong>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">-</td>
                        <td style="text-align: center;"><strong>Quantité non conforme</strong></td>
                        <td style="text-align: center; font-size: 1.2em;">
                            <strong style="color: ${bonReception.quantiteNonConforme > 0 ? 'red' : 'green'};">
                                ${bonReception.quantiteNonConforme}
                            </strong>
                        </td>
                    </tr>
                    
                    <c:if test="${not empty bonReception.commentaire}">
                        <tr>
                            <td>-</td>
                            <td style="text-align: center;"><strong>Commentaire</strong></td>
                            <td>${bonReception.commentaire}</td>
                        </tr>
                    </c:if>
                    
                    <tr>
                        <td colspan="3" style="background-color: #e9ecef; font-weight: bold; text-align: center;">
                            INFORMATIONS FOURNISSEUR
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: center;">
                            ${bonLivraison.bonCommande.proforma.fournisseur.nom}
                            <c:if test="${not empty bonLivraison.bonCommande.proforma.fournisseur.email}">
                                (${bonLivraison.bonCommande.proforma.fournisseur.email})
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">${bonLivraison.transporteur}</td>
                        <td style="text-align: center;"><strong>Transporteur</strong></td>
                        <td>-</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        
        <hr>
        
        <h3>Validation de la réception</h3>
        <c:if test="${bonLivraison.statut != 'RECU'}">
            <form action="${pageContext.request.contextPath}/bonReception/valider" method="post" 
                  onsubmit="return confirm('Êtes-vous sûr de vouloir valider cette réception ? Cette action est irréversible.');">
                <input type="hidden" name="idBonLivraison" value="${bonLivraison.idBonLivraison}" />
                <input type="hidden" name="idBonReception" value="${bonReception.idBonReception}" />
                
                <p>
                    <button type="submit" style="padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer;">
                        ✅ Valider la réception et mettre à jour le stock
                    </button>
                </p>
                
                <p style="color: #666; font-size: 0.9em;">
                    <em>Note: Cette action marquera le bon de livraison comme reçu et déclenchera 
                    la mise à jour du stock et du mouvement de caisse.</em>
                </p>
            </form>
        </c:if>
        
        <c:if test="${bonLivraison.statut == 'RECU'}">
            <p style="color: green; font-weight: bold;">
                ✅ Cette réception a déjà été validée.
            </p>
        </c:if>
    </c:if>
    
    <c:if test="${empty bonLivraison || empty bonReception}">
        <p style="color: red;">Données manquantes pour effectuer la comparaison.</p>
    </c:if>
</body>
</html>
