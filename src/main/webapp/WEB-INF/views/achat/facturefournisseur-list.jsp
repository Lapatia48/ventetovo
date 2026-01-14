<%-- achat/facturefournisseur-list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Factures Fournisseurs</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .statut-en_attente { color: #ff9800; }
        .statut-reglee { color: #4caf50; }
        .statut-en_retard { color: #f44336; }
        .statut-annulee { color: #9e9e9e; }
        a { text-decoration: none; color: #2196f3; }
        a:hover { text-decoration: underline; }
        .btn-action { 
            padding: 5px 10px;
            margin: 2px;
            border-radius: 3px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
        }
        .btn-regler { background-color: #4caf50; color: white; }
        .btn-detail { background-color: #2196f3; color: white; }
    </style>
</head>
<body>
    <h2>🧾 Factures Fournisseurs</h2>
    
    <c:if test="${not empty success}">
        <p style="color: #4caf50; background-color: #d4edda; padding: 10px; border-radius: 5px;">
            ✅ ${success}
        </p>
    </c:if>
    
    <c:if test="${not empty error}">
        <p style="color: #f44336; background-color: #f8d7da; padding: 10px; border-radius: 5px;">
            ❌ ${error}
        </p>
    </c:if>
    
    <c:if test="${empty factures}">
        <p>Aucune facture trouvée.</p>
    </c:if>
    
    <c:if test="${not empty factures}">
        <table>
            <thead>
                <tr>
                    <th>N° Facture</th>
                    <th>N° BC</th>
                    <th>Fournisseur</th>
                    <th>Date Facture</th>
                    <th>Échéance</th>
                    <th>Montant</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="facture" items="${factures}">
                    <tr>
                        <td>${facture.numeroFacture}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/bc/detail/${facture.idBonCommande}">
                                BC #${facture.idBonCommande}
                            </a>
                        </td>
                        <td>
                            <c:if test="${not empty facture.bonCommande && not empty facture.bonCommande.proforma && not empty facture.bonCommande.proforma.fournisseur}">
                                ${facture.bonCommande.proforma.fournisseur.nom}
                            </c:if>
                            <c:if test="${empty facture.bonCommande || empty facture.bonCommande.proforma || empty facture.bonCommande.proforma.fournisseur}">
                                -
                            </c:if>
                        </td>
                        <td>${facture.dateFacture}</td>
                        <td>
                            ${facture.dateEcheance}
                            <c:if test="${facture.statut == 'EN_RETARD'}">
                                <span style="color: #f44336;">⚠️ En retard</span>
                            </c:if>
                        </td>
                        <td><strong>${facture.montantTotal} Ar</strong></td>
                        <td class="statut-${facture.statut.toLowerCase()}">
                            ${facture.statut}
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/factureFournisseur/detail/${facture.idFacture}" 
                               class="btn-action btn-detail">
                                Détail
                            </a>
                            
                            <c:if test="${facture.statut == 'EN_ATTENTE'}">
                                <form action="${pageContext.request.contextPath}/factureFournisseur/regler" 
                                      method="post" style="display: inline;">
                                    <input type="hidden" name="idFacture" value="${facture.idFacture}">
                                    <button type="submit" class="btn-action btn-regler">
                                        Régler
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <br>
    <a href="${pageContext.request.contextPath}/bc/list">← Retour aux bons de commande</a> |
    <a href="${pageContext.request.contextPath}/bonLivraison/list">Bons de livraison</a> |
    <a href="${pageContext.request.contextPath}/achat/achat">🏠 Menu achat</a>
</body>
</html>    <br>
    <a href="${pageContext.request.contextPath}/bc/list">← Retour aux bons de commande</a>
    &nbsp;&nbsp;
    <a href="${pageContext.request.contextPath}/achat/achat">🏠 Accueil</a>
</body>
</html>