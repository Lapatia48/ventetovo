<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Proformas - Comparaison des prix</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .selectionne { background-color: #d4edda; }
        .en-attente { background-color: #fff3cd; }
        .rejete { background-color: #f8d7da; }
        .prix-min { background-color: #c8e6c9 !important; font-weight: bold; }
        .prix-min td:nth-child(3) { color: #2e7d32; }
    </style>
</head>
<body>
    <h2>Comparaison des Proformas</h2>
    
    <c:if test="${not empty article}">
        <p><strong>Article:</strong> ${article.code} - ${article.designation}</p>
        <p><strong>Quantité demandée:</strong> ${quantite}</p>
        <p><strong>Token de la demande:</strong> ${tokenDemande}</p>
    </c:if>
    
    <table id="proformasTable">
        <thead>
            <tr>
                <th>N° Proforma</th>
                <th>Fournisseur</th>
                <th>Prix Unitaire</th>
                <th>Quantité</th>
                <th>Montant Total</th>
                <th>Date</th>
                <th>Statut</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="proforma" items="${proformas}" varStatus="status">
                <tr class="${proforma.statut.toLowerCase().replace('é', 'e')}" 
                    data-prix="${proforma.prixUnitaire}"
                    data-id="${proforma.idProforma}"
                    data-status="${proforma.statut}">
                    <td>${proforma.numero}</td>
                    <td>
                        <c:if test="${not empty proforma.fournisseur}">
                            ${proforma.fournisseur.nom}
                        </c:if>
                        <c:if test="${empty proforma.fournisseur}">
                            Fournisseur #${proforma.idFournisseur}
                        </c:if>
                    </td>
                    <td class="prix-cell">${proforma.prixUnitaire} Ar</td>
                    <td>${proforma.quantite}</td>
                    <td class="montant-cell">${proforma.montantTotal} Ar</td>
                    <td>${proforma.dateProforma}</td>
                    <td class="statut-cell">${proforma.statut}</td>
                    <td class="action-cell">
                        <c:if test="${proforma.statut == 'EN_ATTENTE'}">
                            <form action="${pageContext.request.contextPath}/achat/selectionner" 
                                  method="post" style="display: inline;" 
                                  class="selection-form" data-proforma-id="${proforma.idProforma}">
                                <input type="hidden" name="idProforma" value="${proforma.idProforma}">
                                <input type="hidden" name="tokenDemande" value="${tokenDemande}">
                                <button type="submit" class="select-btn">Sélectionner</button>
                            </form>
                        </c:if>
                        <c:if test="${proforma.statut == 'SELECTIONNE'}">
                            <span class="selected-badge"> Sélectionné</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
        
    <br>
    <a href="${pageContext.request.contextPath}/achat/achat">Retour à la liste des articles</a>
    <br>
    <a href="${pageContext.request.contextPath}/achat/demandes">Voir toutes les demandes</a>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialiser la comparaison des prix
            comparerPrix();
            
            // Ajouter un événement pour réinitialiser la comparaison si nécessaire
            document.getElementById('proformasTable').addEventListener('click', function(e) {
                if (e.target.classList.contains('select-btn')) {
                    // On pourrait ajouter une confirmation ici
                    // e.preventDefault();
                    // if (confirm('Voulez-vous vraiment sélectionner cette proforma ?')) {
                    //     e.target.closest('form').submit();
                    // }
                }
            });
        });
        
        function comparerPrix() {
            const rows = document.querySelectorAll('#proformasTable tbody tr');
            const enAttenteRows = [];
            let minPrix = Infinity;
            let minPrixRow = null;
            let prixList = [];
            
            // Parcourir toutes les lignes
            rows.forEach(row => {
                const prixValue = parseFloat(row.getAttribute('data-prix'));
                const status = row.getAttribute('data-status');
                
                if (!isNaN(prixValue)) {
                    prixList.push(prixValue);
                    
                    // Ne considérer que les proformas en attente pour le prix minimum
                    if (status === 'EN_ATTENTE') {
                        enAttenteRows.push(row);
                        
                        if (prixValue < minPrix) {
                            minPrix = prixValue;
                            minPrixRow = row;
                        }
                    }
                }
            });
            
            // Mettre en évidence le prix minimum
            if (minPrixRow) {
                minPrixRow.classList.add('prix-min');
                
                // Cacher les boutons "Sélectionner" des autres proformas en attente
                enAttenteRows.forEach(row => {
                    if (row !== minPrixRow) {
                        const selectBtn = row.querySelector('.select-btn');
                        const form = row.querySelector('.selection-form');
                        if (selectBtn) {
                            selectBtn.style.display = 'none';
                            // Ajouter un message d'info
                            const actionCell = row.querySelector('.action-cell');
                            const infoSpan = document.createElement('span');
                            infoSpan.textContent = '⚠️ Prix plus élevé';
                            infoSpan.style.color = '#6c757d';
                            infoSpan.style.fontSize = '0.9em';
                            actionCell.appendChild(infoSpan);
                        }
                    }
                });
            }
            
        }

    </script>
</body>
</html>