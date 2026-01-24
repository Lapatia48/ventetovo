<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Validation des commandes</title>
</head>
<body>

<h2>Commandes à valider</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table border="1" width="100%">
    <tr>
        <th>ID</th>
        <th>Numéro</th>
        <th>Client</th>
        <th>Statut</th>
        <th>Action</th>
    </tr>

    <c:forEach var="cmd" items="${commandes}">
    <tr>
        <td>${cmd.idCommande}</td>
        <td>${cmd.numeroCommande}</td>
        <td>${cmd.idClient}</td>
        <td>${cmd.statut}</td>
        <td>

            <c:if test="${cmd.statut == 'A_VALIDER'}">

                <form action="${pageContext.request.contextPath}/vente/commandes/valider"
                      method="post" style="display:inline;">
                    <input type="hidden" name="idCommande" value="${cmd.idCommande}">
                    <button type="submit">✅ Valider</button>
                </form>

                <form action="${pageContext.request.contextPath}/vente/commandes/refuser"
                      method="post" style="display:inline;">
                    <input type="hidden" name="idCommande" value="${cmd.idCommande}">
                    <input type="text" name="motif" placeholder="Motif" required>
                    <button type="submit">❌ Refuser</button>
                </form>

            </c:if>

        </td>
    </tr>
</c:forEach>

</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">← Retour</a>

</body>
</html>
