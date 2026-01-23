<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Connexion - Ventetovo</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login_stock.css">
</head>
<body>
  <div class="login-container">
    <h1>Connexion</h1>
    <p class="subtitle">Bienvenue sur la plateforme de Stock</p>
    
    <form action="${pageContext.request.contextPath}/login" method="POST">
      <div class="form-group">
        <label for="username">Nom d'utilisateur</label>
        <input type="text" id="username" name="username" required>
      </div>
      
      <div class="form-group">
        <label for="password">Mot de passe</label>
        <input type="password" id="password" name="password" required>
      </div>
      
      <button type="submit">Se connecter</button>
    </form>
  </div>
</body>
</html>