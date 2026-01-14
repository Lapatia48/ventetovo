<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quantité</title>
</head>
<body>
    <form action="${pageContext.request.contextPath}/achat/quantite" method="post">
        <label for="quantite">Quantité:</label>
        <input type="number" id="quantite" name="quantite" min="1" required>
        <input type="hidden" name="idArticle" value="${idArticle}">
        <button type="submit">Valider</button>
    </form>
</body>
</html>