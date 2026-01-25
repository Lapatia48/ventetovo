<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Historique</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="container">
    <!-- Left Navbar -->
    <nav class="navbar">
        <h2>Stock Menu</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/articles">Liste des articles</a></li>
            <li><a href="${pageContext.request.contextPath}/mouvements">Historique des mouvements</a></li>
            <li><a href="#">Initialisation Transfert</a></li>
            <li><a href="#">Revue final Transfert</a></li>
            <li><a href="#">Comparaison stock théorique & stock actuel</a></li>
        </ul>
    </nav>

    <!-- Right Content -->
    <div class="content-wrapper">
        <h1>Historique des mouvements</h1>

        <table>
            <thead>
                <tr>
                    <th>Dépôt</th>
                    <th>Méthode Article</th>
                    <th>Article</th>
                    <th>Quantité</th>
                    <th>Prix Total</th>
                    <th>Prix Unitaire</th>
                    <th>Type Mouvement</th>
                    <th>Date Mouvement</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="mvt" items="${mouvements}">
                    <tr>
                        <td>${mvt.depot.nomDepot}</td>

                        <td>${mvt.methodeArticle.methode.nomMethode}</td>

                        <td>${mvt.article.designation}</td>

                        <td>
                            <fmt:formatNumber value="${mvt.quantiteStock}"
                                            type="number"
                                            maxFractionDigits="3"/>
                        </td>

                        <!-- Prix total = quantite * prix_article -->
                        <td>
                            <fmt:formatNumber
                                value="${mvt.quantiteStock * mvt.prixArticle}"
                                type="number"
                                maxFractionDigits="2"/>
                        </td>

                        <td>
                            <fmt:formatNumber value="${mvt.prixArticle}"
                                            type="number"
                                            maxFractionDigits="2"/>
                        </td>

                        <td>${mvt.mouvementType}</td>

                        <td>
                            <fmt:formatDate
                                value="${mvt.dateEntreeStockAsDate}"
                                pattern="dd/MM/yyyy HH:mm:ss"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </div>
</div>
</body>
</html>
