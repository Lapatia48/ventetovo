<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head>
    <title>Gestion des Devis</title>
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
            padding:5px 10px;
            border:none;
            border-radius:4px;
            cursor:pointer;
        }
        .ok { background:#28a745; color:white; }
        .no { background:#dc3545; color:white; }
        .cmd { background:#007bff; color:white; }
    </style>
</head>
<body>

<h2>Liste des devis</h2>

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
        <th>Statut</th>
        <th>Total TTC</th>
        <th>Validateur</th>
        <th>Date validation</th>
        <th>Actions</th>
    </tr>

    <c:forEach var="devis" items="${devisList}">
        <tr>
            <td>${devis.idDevis}</td>
            <td>${devis.numeroDevis}</td>
            <td>${devis.idClient}</td>
            <td>${devis.statut}</td>
            <td>${devis.montantTtc}</td>

            <!-- Validateur -->
            <td>
                <c:choose>
                    <c:when test="${not empty devis.idValidateur}">
                        ${devis.idValidateur}
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </td>

            <!-- Date validation -->
            <td>
                <c:choose>
                    <c:when test="${not empty devis.dateValidation}">
                        ${devis.dateValidation}
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </td>

            <!-- Actions -->
            <td>

                <!-- Validation possible uniquement si A_VALIDER -->
                <c:if test="${devis.statut == 'A_VALIDER'}">

                    <!-- Rôles autorisés -->
                    <c:if test="${utilisateur.nomRole == 'ADMIN'
                               || utilisateur.nomRole == 'VALIDEUR_N1'
                               || utilisateur.nomRole == 'VALIDEUR_N2'}">

                        <form action="${pageContext.request.contextPath}/vente/devis/valider" method="post" style="display:inline;">
                            <input type="hidden" name="idDevis" value="${devis.idDevis}">
                            <button type="submit" class="btn ok">Valider</button>
                        </form>

                        <form action="${pageContext.request.contextPath}/vente/devis/refuser" method="post" style="display:inline;">
                            <input type="hidden" name="idDevis" value="${devis.idDevis}">
                            <input type="text" name="motif" placeholder="Motif" required>
                            <button type="submit" class="btn no">Refuser</button>
                        </form>

                    </c:if>
                </c:if>

                <!-- Créer commande uniquement si accepté -->
                <c:if test="${devis.statut == 'ACCEPTE'}">
                    <a class="btn cmd"
                       href="${pageContext.request.contextPath}/vente/commandes/nouveau?idDevis=${devis.idDevis}">
                        Créer commande
                    </a>
                </c:if>

            </td>
        </tr>
    </c:forEach>
</table>


<br>
<a href="${pageContext.request.contextPath}/vente/accueil">← Retour accueil</a>

</body>
</html>
