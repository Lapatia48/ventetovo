<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Module Vente</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        h1 { color: #333; margin-bottom: 20px; }
        .nav { background: #2c3e50; padding: 15px; margin-bottom: 20px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; padding: 8px 15px; border-radius: 4px; }
        .nav a:hover { background: #34495e; }
        .article-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .article-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .article-card h3 { color: #2c3e50; margin-bottom: 10px; }
        .article-card p { color: #666; margin: 5px 0; }
        .btn { display: inline-block; padding: 10px 20px; background: #3498db; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; }
        .btn:hover { background: #2980b9; }
        .btn-success { background: #27ae60; }
        .btn-success:hover { background: #229954; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="${pageContext.request.contextPath}/vente/vente">Articles</a>
        <a href="${pageContext.request.contextPath}/vente/clients">Clients</a>
        <a href="${pageContext.request.contextPath}/vente/proforma/list">Proformas</a>
        <a href="${pageContext.request.contextPath}/vente/bc/list">Bons de commande</a>
        <a href="${pageContext.request.contextPath}/vente/facture/list">Factures</a>
        <a href="${pageContext.request.contextPath}/vente/bl/list">Livraisons</a>
        <a href="${pageContext.request.contextPath}/vente/stock">Stock</a>
    </div>

    <div class="container">
        <h1>Module Vente - Liste des Articles</h1>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="article-grid">
            <c:forEach var="article" items="${articles}">
                <div class="article-card">
                    <h3>${article.designation}</h3>
                    <p><strong>Code:</strong> ${article.codeArticle}</p>
                    <p><strong>Catégorie:</strong> ${article.categorie}</p>
                    <a href="${pageContext.request.contextPath}/vente/proforma/form?idArticle=${article.idArticle}" class="btn">
                        Créer un proforma
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
