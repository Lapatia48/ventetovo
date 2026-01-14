<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Bons de Commande</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .statut-en-cours { color: #ff9800; }
        .statut-livre { color: #4caf50; }
        .statut-annule { color: #f44336; }
        a { text-decoration: none; color: #2196f3; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h2> Liste des Bons de Commande</h2>
    
    <c:if test="${empty bonsCommande}">
        <p>Aucun bon de commande trouvé.</p>
    </c:if>
    
    <c:if test="${not empty bonsCommande}">
        <table>
            <thead>
                <tr>
                    <th>N° BC</th>
                    <th>Date</th>
                    <th>Fournisseur</th>
                    <th>Article</th>
                    <th>Quantité</th>
                    <th>Montant</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="bc" items="${bonsCommande}">
                    <tr>
                        <td>${bc.idBonCommande}</td>
                        <td>${bc.dateCommande}</td>
                        <td>${bc.nomFournisseur}</td>
                        <td>${bc.designationArticle}</td>
                        <td>${bc.quantite}</td>
                        <td>${bc.montantTotal} Ar</td>
                        <td class="statut-${bc.statut.toLowerCase()}">
                            ${bc.statut}
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/bc/detail/${bc.idBonCommande}">
                                Voir détail
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <br>
    <a href="${pageContext.request.contextPath}/achat/achat">← Retour au menu achat</a> |
    <a href="${pageContext.request.contextPath}/factureFournisseur/list">Liste des factures</a>
</body>
</html>