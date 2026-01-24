<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Créer Commande Client</title>
    <style>
        table {
            width:100%;
            border-collapse: collapse;
        }
        th, td {
            border:1px solid #ccc;
            padding:8px;
            text-align:center;
        }
        th {
            background:#f2f2f2;
        }
        .btn {
            padding:6px 12px;
            background:#28a745;
            color:white;
            border:none;
            cursor:pointer;
            border-radius:4px;
        }
    </style>
</head>
<body>

<h2>Devis disponibles pour création de commande</h2>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<table>
    <tr>
        <th>ID</th>
        <th>Numéro</th>
        <th>Client</th>
        <th>Total TTC</th>
        <th>Action</th>
    </tr>

    <c:forEach var="devis" items="${devisList}">
        <tr>
            <td>${devis.idDevis}</td>
            <td>${empty devis.numeroDevis ? 'N/A' : devis.numeroDevis}</td>
            <td>${devis.idClient}</td>
            <td>${devis.montantTtc}</td>
            <td>
                <a class="btn"
                    href="${pageContext.request.contextPath}/vente/commandes/nouveau?idDevis=${devis.idDevis}">
                    Créer commande
                    </a>
            </td>
        </tr>
    </c:forEach>

</table>

<br>
<a href="${pageContext.request.contextPath}/vente/accueil">← Retour accueil</a>

</body>
</html>
