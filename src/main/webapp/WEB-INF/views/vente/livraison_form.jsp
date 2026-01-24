<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Nouvelle Livraison</title>
</head>
<body>

<h2>Préparer livraison</h2>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/vente/livraisons/creer">

    <input type="hidden" name="idCommande" value="${commande.idCommande}" />

    <p>
        <strong>Commande :</strong> ${empty commande.numeroCommande ? 'N/A' : commande.numeroCommande}
    </p>

    <p>
        <strong>Date commande :</strong> ${commande.dateCommande}
    </p>

    <p>
        <label>Transporteur :</label><br>
        <input type="text" name="transporteur" required />
    </p>

    <p>
        <label>Numéro de suivi :</label><br>
        <input type="text" name="numeroSuivi" />
    </p>

    <!-- ✅ TABLE DOIT ÊTRE ICI -->
    <table border="1">
        <tr>
            <th>Article</th>
            <th>Qté commandée</th>
            <th>Déjà livrée</th>
            <th>Reste</th>
            <th>À livrer</th>
        </tr>

        <c:forEach items="${lignesCommande}" var="ligne">
            <c:set var="qtyLivree" value="${ligne.quantiteLivree != null ? ligne.quantiteLivree : 0}" />
            <c:set var="reste" value="${ligne.quantiteCommandee - qtyLivree}" />

            <tr>
                <td>${ligne.idArticle}</td>
                <td>${ligne.quantiteCommandee}</td>
                <td>${qtyLivree}</td>
                <td>${reste}</td>
                <td>
                    <c:choose>
                        <c:when test="${reste > 0}">
                            <input type="number"
                                   name="qty_${ligne.idLigneCommande}"
                                   min="0"
                                   max="${reste}"
                                   value="${reste}" />
                        </c:when>
                        <c:otherwise>
                            <span style="color: gray;">Complet</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </table>

    <br>
    <button type="submit">Créer la livraison</button>

</form>

<br>
<a href="${pageContext.request.contextPath}/vente/livraisons">⬅ Retour</a>

</body>
</html>
