<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Proformas - Comparaison des prix</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .selectionne { background-color: #d4edda; }
        .en-attente { background-color: #fff3cd; }
        .rejete { background-color: #f8d7da; }
    </style>
</head>
<body>
    <h2>Comparaison des Proformas</h2>
    
    <c:if test="${not empty article}">
        <p><strong>Article:</strong> ${article.code} - ${article.designation}</p>
        <p><strong>Quantité demandée:</strong> ${quantite}</p>
        <p><strong>Token de la demande:</strong> ${tokenDemande}</p>
    </c:if>
    
    <table>
        <thead>
            <tr>
                <th>N° Proforma</th>
                <th>Fournisseur</th>
                <th>Prix Unitaire</th>
                <th>Quantité</th>
                <th>Montant Total</th>
                <th>Date</th>
                <th>Statut</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="proforma" items="${proformas}">
                <tr class="${proforma.statut.toLowerCase().replace('é', 'e')}">
                    <td>${proforma.numero}</td>
                    <td>
                        <c:if test="${not empty proforma.fournisseur}">
                            ${proforma.fournisseur.nom}
                        </c:if>
                        <c:if test="${empty proforma.fournisseur}">
                            Fournisseur #${proforma.idFournisseur}
                        </c:if>
                    </td>
                    <td>${proforma.prixUnitaire} Ar</td>
                    <td>${proforma.quantite}</td>
                    <td>${proforma.montantTotal} Ar</td>
                    <td>${proforma.dateProforma}</td>
                    <td>${proforma.statut}</td>
                    <td>
                        <c:if test="${proforma.statut == 'EN_ATTENTE'}">
                            <form action="${pageContext.request.contextPath}/achat/selectionner" 
                                  method="post" style="display: inline;">
                                <input type="hidden" name="idProforma" value="${proforma.idProforma}">
                                <input type="hidden" name="tokenDemande" value="${tokenDemande}">
                                <button type="submit">Sélectionner</button>
                            </form>
                        </c:if>
                        <c:if test="${proforma.statut == 'SELECTIONNE'}">
                            ✅ Sélectionné
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <br>
    <a href="${pageContext.request.contextPath}/achat/achat">Retour à la liste des articles</a>
    <br>
    <a href="${pageContext.request.contextPath}/achat/demandes">Voir toutes les demandes</a>
</body>
</html>