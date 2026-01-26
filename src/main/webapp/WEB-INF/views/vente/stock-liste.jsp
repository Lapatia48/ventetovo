<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion du Stock</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        h1 { color: #333; margin-bottom: 20px; }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f8f9fa; }
        .btn { display: inline-block; padding: 8px 15px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background: #2980b9; }
        .stock-low { background: #f8d7da; }
        .stock-ok { background: #d4edda; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestion du Stock</h1>

        <table>
            <thead>
                <tr>
                    <th>Article</th>
                    <th>Quantité Disponible</th>
                    <th>Quantité Réservée</th>
                    <th>Réellement Disponible</th>
                    <th>Dernière MAJ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stock" items="${stocks}">
                    <tr class="${stock.quantiteDisponible - stock.quantiteReservee < 10 ? 'stock-low' : 'stock-ok'}">
                        <td>
                            <c:forEach var="article" items="${articles}">
                                <c:if test="${article.idArticle == stock.idArticle}">
                                    ${article.designation}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>${stock.quantiteDisponible}</td>
                        <td>${stock.quantiteReservee}</td>
                        <td><strong>${stock.quantiteDisponible - stock.quantiteReservee}</strong></td>
                        <td>${stock.dateMiseAJour}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/vente/vente" class="btn">Retour</a>
        </div>
    </div>
</body>
</html>
