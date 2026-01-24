<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouveau Devis - Module Vente</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>

<body>
<div style="max-width: 600px; margin: 0 auto; padding: 20px;">
    <h1>Nouveau Devis</h1>

    <!-- Message d'erreur -->
    <c:if test="${not empty error}">
        <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/vente/devis/creer" method="post">

        <!-- Client -->
        <div class="form-group">
            <label for="idClient">Client :</label>
            <select name="idClient" id="idClient" required>
                <option value="">Sélectionner un client</option>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.idClient}">
                        ${empty client.nom ? '' : client.nom} (${empty client.codeClient ? '' : client.codeClient})
                    </option>
                </c:forEach>
            </select>
        </div>

        <!-- Date -->
        <div class="form-group">
            <label for="dateValidite">Date de validité :</label>
            <input type="date" name="dateValidite" id="dateValidite" required>
        </div>

        <!-- Notes -->
        <div class="form-group">
            <label for="notes">Notes :</label>
            <textarea name="notes" id="notes" rows="4"></textarea>
        </div>

        <!-- Si l'utilisateur n'est PAS commercial -->
        <c:if test="${!isCommercial}">
            <div class="form-group">
                <label for="idCommercial">Commercial (création pour le compte de) :</label>
                <select name="idCommercial" id="idCommercial" required>
                    <option value="">Sélectionner un commercial</option>
                    <c:forEach var="comm" items="${commerciaux}">
                        <option value="${comm.idUtilisateur}">
                            ${empty comm.nom ? '' : comm.nom} ${empty comm.prenom ? '' : comm.prenom} (${empty comm.email ? '' : comm.email})
                        </option>
                    </c:forEach>
                </select>
            </div>
        </c:if>

        <!-- Si l'utilisateur EST commercial -->
        <c:if test="${isCommercial and not empty utilisateur}">
            <div class="form-group">
                <label>Commercial :</label>
                <p>
                    <strong>
                        ${empty utilisateur.nom ? '' : utilisateur.nom} ${empty utilisateur.prenom ? '' : utilisateur.prenom} (${empty utilisateur.email ? '' : utilisateur.email})
                    </strong>
                </p>
            </div>
        </c:if>

        <!-- Articles -->
        <div class="form-group">
            <label>Articles sélectionnés :</label>

            <c:choose>
                <c:when test="${not empty selectedArticles}">
                    <ul>
                        <c:forEach var="article" items="${selectedArticles}">
                            <li>
                                <strong>${empty article.designation ? 'N/A' : article.designation}</strong> (${empty article.code ? '' : article.code})

                                <!-- Prix -->
                                <div style="margin-top:6px;">
                                    Prix unitaire :
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty unitPrices[article.idArticle]}">
                                                ${unitPrices[article.idArticle]}
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>

                                <!-- Quantité -->
                                <div style="margin-top:6px;">
                                    Quantité :
                                    <input type="number"
                                           name="qty_${article.idArticle}"
                                           value="1"
                                           min="1"
                                           style="width:80px;" />
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>

                <c:otherwise>
                    <p style="color: #dc3545;">
                        Aucun article sélectionné. Veuillez retourner à la liste des articles.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Bouton -->
        <c:if test="${not empty selectedArticles}">
            <c:choose>
                <c:when test="${isCommercial and not empty utilisateur}">
                    <input type="hidden" name="idCommercial" value="${utilisateur.idUtilisateur}"/>
                    <button type="submit">Créer Devis</button>
                </c:when>

                <c:otherwise>
                    <button type="submit">
                        Créer Devis pour le commercial sélectionné
                    </button>
                    <p style="color: #0a58ca; margin-top: 10px;">
                        Vous créez ce devis au nom du commercial sélectionné.
                    </p>
                </c:otherwise>
            </c:choose>
        </c:if>

        <!-- Annuler -->
        <a href="${pageContext.request.contextPath}/vente/articles"
           style="margin-left: 10px; padding: 10px 20px; background-color: #6c757d; color: white;
           text-decoration: none; border-radius: 4px; display: inline-block;">
            Annuler
        </a>
        

    </form>

    <br>
    <a href="${pageContext.request.contextPath}/vente/accueil">← Retour à l'accueil</a>
</div>
</body>
</html>
