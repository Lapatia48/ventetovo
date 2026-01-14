<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Validation Financière</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        .vert { background-color: #d4edda; }
        .rouge { background-color: #f8d7da; }
        .btn { padding: 10px 20px; margin: 5px; }
    </style>
</head>
<body>
    <h2>Validation Financière</h2>
    
    <c:if test="${not empty proforma}">
        <p><strong>Proforma :</strong> ${proforma.numero}</p>
        <c:if test="${not empty proforma.article}">
            <p><strong>Article :</strong> ${proforma.article.designation}</p>
        </c:if>
        
        <table>
            <tr>
                <th>Description</th>
                <th>Montant (Ar)</th>
                <th>Statut</th>
            </tr>
            <tr>
                <td>Montant Proforma</td>
                <td>${montantProforma}</td>
                <td></td>
            </tr>
            <tr>
                <td>Seuil d'approbation</td>
                <td>${montantSeuil}</td>
                <td></td>
            </tr>
            <tr class="${ecart > 0 ? 'rouge' : 'vert'}">
                <td>Écart (Proforma - Seuil)</td>
                <td>${ecart}</td>
                <td>
                    <c:choose>
                        <c:when test="${ecart > 0}">
                             Dépasse le seuil
                        </c:when>
                        <c:otherwise>
                             Inférieur au seuil
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
        
        <c:choose>
            <c:when test="${ecart > 0}">
                <p style="color: #dc3545; font-weight: bold;">
                     Attention : Cette proforma dépasse le seuil d'approbation de ${ecart} Ar.
                    Une validation supplémentaire est requise.
                </p>
            </c:when>
            <c:otherwise>
                <p style="color: #28a745; font-weight: bold;">
                     Cette proforma est inférieure au seuil d'approbation.
                    Vous pouvez valider sans approbation supplémentaire.
                </p>
            </c:otherwise>
        </c:choose>
                
        <form action="${pageContext.request.contextPath}/achat/validerProforma" method="post">
            <input type="hidden" name="idProforma" value="${idProforma}">
            <input type="hidden" name="tokenDemande" value="${tokenDemande}">
            
            <!-- Input hidden selon le seuil -->
            <c:choose>
                <c:when test="${ecart <= 0}">
                    <!-- Seuil non dépassé : magasinier peut valider -->
                    <input type="hidden" name="emailAutorise" value="magasinier@vente.com">
                </c:when>
                <c:otherwise>
                    <!-- Seuil dépassé : seulement valideur N1 peut valider -->
                    <input type="hidden" name="emailAutorise" value="valideur1@vente.com">
                </c:otherwise>
            </c:choose>
            
            <p>
                <input type="checkbox" id="confirmation" name="confirmation" value="oui" required>
                <label for="confirmation">Je confirme vouloir valider cette proforma</label>
            </p>
            
            <button type="submit" class="btn" 
                    style="background-color: ${ecart > 0 ? '#dc3545' : '#28a745'}; color: white;">
                ${ecart > 0 ? 'Valider (Dépassement - Valideur N1)' : 'Valider (Magasinier)'}
            </button>
            
            <a href="${pageContext.request.contextPath}/achat/proformas?token=${tokenDemande}" 
            style="padding: 10px 20px; background-color: #6c757d; color: white; text-decoration: none;">
                Retour aux proformas
            </a>
        </form>
    </c:if>
    
    <c:if test="${empty proforma}">
        <p style="color: red;">Erreur : Proforma introuvable</p>
        <a href="${pageContext.request.contextPath}/achat/achat">Retour à l'accueil</a>
    </c:if>
</body>
</html>