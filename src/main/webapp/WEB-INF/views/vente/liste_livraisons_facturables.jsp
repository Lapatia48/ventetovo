<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<h2>📄 Livraisons facturables</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" width="100%">
    <tr>
        <th>Livraison</th>
        <th>Commande</th>
        <th>Date</th>
        <th>Statut</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${livraisons}" var="liv">
        <tr>
            <td>${liv.numeroLivraison}</td>
            <td>${liv.idCommande}</td>
            <td>${liv.dateLivraison}</td>
            <td>${liv.statut}</td>
            <td>
                <form method="post"
                      action="${pageContext.request.contextPath}/vente/factures/creer">
                    <input type="hidden" name="idLivraison" value="${liv.idLivraison}" />
                    <button type="submit">Créer facture</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">⬅ Retour</a>
