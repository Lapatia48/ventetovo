<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste Articles - Module Vente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .articles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .article-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            background: #fafafa;
            text-align: center;
        }
        .article-card h3 {
            margin: 0 0 10px 0;
            color: #333;
        }
        .article-card p {
            margin: 5px 0;
            color: #666;
        }
        .add-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 15px;
            transition: background 0.3s;
        }
        .add-btn:hover {
            background: #218838;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .cart-info {
            background: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Articles - Sélection pour Devis</h1>
        
        <c:if test="${not empty message}">
            <div style="background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                ${message}
            </div>
        </c:if>
        
        <div class="cart-info">
            <strong>Articles sélectionnés pour le devis:</strong> <span id="selected-count">0</span> article(s)
            <br>
            <div id="selected-list" style="margin-top: 10px;"></div>
            <form action="${pageContext.request.contextPath}/vente/devis/nouveau" method="post" style="display: inline;">
                <input type="hidden" name="selectedArticles" id="selectedArticlesInput" value="">
                <button type="submit" id="create-devis-btn" style="background: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; margin-top: 10px;" disabled>Créer Devis</button>
            </form>
        </div>
        
        <div class="articles-grid">
            <c:forEach var="article" items="${articles}">
                <div class="article-card">
                    <h3>${empty article.designation ? 'N/A' : article.designation}</h3>
                    <p><strong>Référence:</strong> ${empty article.code ? 'N/A' : article.code}</p>
                    <p><strong>ID:</strong> ${article.idArticle != null ? article.idArticle : 'N/A'}</p>
                    <button type="button" class="add-btn" onclick="ajouterArticle(${article.idArticle != null ? article.idArticle : 0})">+ Ajouter</button>
                </div>
            </c:forEach>
        </div>
        
        <a href="${pageContext.request.contextPath}/vente/accueil" class="back-link">← Retour à l'accueil</a>
    </div>

    <script>
        let selectedArticles = [];
        
        function ajouterArticle(idArticle) {
            if (!selectedArticles.includes(idArticle)) {
                selectedArticles.push(idArticle);
                updateUI();
                alert('Article ajouté à la sélection');
            } else {
                alert('Article déjà sélectionné');
            }
        }
        
        function retirerArticle(idArticle) {
            selectedArticles = selectedArticles.filter(id => id !== idArticle);
            updateUI();
        }
        
        function updateUI() {
            document.getElementById('selected-count').textContent = selectedArticles.length;
            document.getElementById('selectedArticlesInput').value = JSON.stringify(selectedArticles);
            document.getElementById('create-devis-btn').disabled = selectedArticles.length === 0;
            
            const listDiv = document.getElementById('selected-list');
            listDiv.innerHTML = '';
            selectedArticles.forEach(id => {
                const item = document.createElement('div');
                item.textContent = 'Article ID: ' + id + ' ';
                const removeBtn = document.createElement('button');
                removeBtn.textContent = 'Retirer';
                removeBtn.onclick = () => retirerArticle(id);
                removeBtn.style.background = '#ff6b6b';
                removeBtn.style.color = 'white';
                removeBtn.style.border = 'none';
                removeBtn.style.padding = '2px 5px';
                removeBtn.style.borderRadius = '3px';
                removeBtn.style.cursor = 'pointer';
                item.appendChild(removeBtn);
                listDiv.appendChild(item);
            });
        }
    </script>
</body>
</html>