<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bon de Réception</title>
</head>
<body>
    <h2>📦 Créer un Bon de Réception</h2>
    
    <p><a href="${pageContext.request.contextPath}/bonLivraison/list">← Retour à la liste</a></p>
    
    <c:if test="${not empty error}">
        <p style="color: red; font-weight: bold;">${error}</p>
    </c:if>
    
    <c:if test="${not empty info}">
        <p style="color: orange; font-weight: bold;">${info}</p>
    </c:if>
    
    <c:if test="${not empty bonLivraison}">
        <h3>Informations du Bon de Livraison</h3>
        <table border="1">
            <tr>
                <td><strong>Numéro livraison:</strong></td>
                <td>${bonLivraison.numeroLivraison}</td>
            </tr>
            <tr>
                <td><strong>Date livraison:</strong></td>
                <td>${bonLivraison.dateLivraison}</td>
            </tr>
            <tr>
                <td><strong>Transporteur:</strong></td>
                <td>${bonLivraison.transporteur}</td>
            </tr>
            <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                <tr>
                    <td><strong>Article:</strong></td>
                    <td>${bonLivraison.bonCommande.proforma.article.designation}</td>
                </tr>
                <tr>
                    <td><strong>Quantité commandée:</strong></td>
                    <td>${bonLivraison.bonCommande.proforma.quantite}</td>
                </tr>
                <tr>
                    <td><strong>Fournisseur:</strong></td>
                    <td>${bonLivraison.bonCommande.proforma.fournisseur.nom}</td>
                </tr>
            </c:if>
        </table>
        
        <hr>
        
        <c:if test="${empty receptionExistante}">
            <h3>Enregistrer la Réception</h3>
            <form action="${pageContext.request.contextPath}/bonReception/enregistrer" method="post">
                <input type="hidden" name="idBonLivraison" value="${bonLivraison.idBonLivraison}" />
                
                <c:if test="${not empty bonLivraison.bonCommande && not empty bonLivraison.bonCommande.proforma}">
                    <input type="hidden" name="idArticle" value="${bonLivraison.bonCommande.proforma.idArticle}" />
                    <input type="hidden" name="quantiteCommandee" value="${bonLivraison.bonCommande.proforma.quantite}" />
                    
                    <table>
                        <tr>
                            <td><label for="quantiteRecue">Quantité reçue:</label></td>
                            <td>
                                <input type="number" 
                                       id="quantiteRecue" 
                                       name="quantiteRecue" 
                                       min="0" 
                                       max="${bonLivraison.bonCommande.proforma.quantite}" 
                                       value="${bonLivraison.bonCommande.proforma.quantite}" 
                                       required />
                            </td>
                        </tr>
                        <tr>
                            <td><label for="quantiteNonConforme">Quantité non conforme:</label></td>
                            <td>
                                <input type="number" 
                                       id="quantiteNonConforme" 
                                       name="quantiteNonConforme" 
                                       min="0" 
                                       value="0" />
                            </td>
                        </tr>
                        <tr>
                            <td><label for="commentaire">Commentaire:</label></td>
                            <td>
                                <textarea id="commentaire" 
                                          name="commentaire" 
                                          rows="3" 
                                          cols="40" 
                                          placeholder="Remarques éventuelles..."></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <button type="submit">Enregistrer la réception</button>
                                <a href="${pageContext.request.contextPath}/bonLivraison/detail/${bonLivraison.idBonLivraison}">
                                    <button type="button">Annuler</button>
                                </a>
                            </td>
                        </tr>
                    </table>
                </c:if>
                
                <c:if test="${empty bonLivraison.bonCommande || empty bonLivraison.bonCommande.proforma}">
                    <p style="color: red;">Impossible de créer le bon de réception: informations manquantes.</p>
                </c:if>
            </form>
        </c:if>
        
        <c:if test="${not empty receptionExistante}">
            <p><a href="${pageContext.request.contextPath}/bonReception/comparaison/${bonLivraison.idBonLivraison}">
                Voir la comparaison BL/BR
            </a></p>
        </c:if>
    </c:if>
    
    <c:if test="${empty bonLivraison}">
        <p style="color: red;">Bon de livraison introuvable.</p>
    </c:if>
</body>
</html>
