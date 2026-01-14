<%-- achat/bonlivraison-list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bons de Livraison</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .statut-en_attente { color: #ff9800; }
        .statut-recu { color: #4caf50; }
        .statut-partiel { color: #2196f3; }
        .statut-annule { color: #f44336; }
        a { text-decoration: none; color: #2196f3; }
        a:hover { text-decoration: underline; }
        .btn-action { 
            padding: 5px 10px;
            margin: 2px;
            border-radius: 3px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
        }
        .btn-receptionner { background-color: #4caf50; color: white; }
        .btn-detail { background-color: #2196f3; color: white; }
        .success-message {
            color: #4caf50;
            background-color: #d4edda;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h2>🚚 Bons de Livraison</h2>
    
    <c:if test="${not empty success}">
        <div class="success-message">
            ✅ ${success}
        </div>
    </c:if>
    
    <c:if test="${not empty error}">
        <p style="color: #f44336; background-color: #f8d7da; padding: 10px; border-radius: 5px;">
            ❌ ${error}
        </p>
    </c:if>
    
    <c:if test="${empty bonLivraisons}">
        <p>Aucun bon de livraison trouvé.</p>
    </c:if>
    
    <c:if test="${not empty bonLivraisons}">
        <table>
            <thead>
                <tr>
                    <th>N° Livraison</th>
                    <th>N° BC</th>
                    <th>Date Livraison</th>
                    <th>Transporteur</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="livraison" items="${bonLivraisons}">
                    <tr>
                        <td>${livraison.numeroLivraison}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/bc/detail/${livraison.idBonCommande}">
                                BC #${livraison.idBonCommande}
                            </a>
                        </td>
                        <td>${livraison.dateLivraison}</td>
                        <td>${livraison.transporteur}</td>
                        <td class="statut-${livraison.statut.toLowerCase()}">
                            ${livraison.statut}
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/bonLivraison/detail/${livraison.idBonLivraison}" 
                               class="btn-action btn-detail">
                                Détail
                            </a>
                            
                            <c:if test="${livraison.statut == 'EN_ATTENTE'}">
                                <form action="${pageContext.request.contextPath}/bonLivraison/receptionner" 
                                      method="post" style="display: inline;">
                                    <input type="hidden" name="idBonLivraison" value="${livraison.idBonLivraison}">
                                    <button type="submit" class="btn-action btn-receptionner">
                                        Réceptionner
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <br>
    <a href="${pageContext.request.contextPath}/factureFournisseur/list">← Retour aux factures</a>
    &nbsp;&nbsp;
    <a href="${pageContext.request.contextPath}/achat/achat">🏠 Accueil</a>
</body>
</html>