<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Configuration Valorisation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 {
            color: #333;
            font-size: 28px;
        }
        .content {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table thead {
            background: #667eea;
            color: white;
        }
        .table th, .table td {
            padding: 15px;
            text-align: left;
        }
        .table tr:nth-child(even) {
            background: #f8f9fa;
        }
        select, input[type="number"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 100%;
        }
        .btn {
            padding: 8px 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn:hover {
            background: #764ba2;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-fifo {
            background: #28a745;
            color: white;
        }
        .badge-cmup {
            background: #17a2b8;
            color: white;
        }
    </style>
    <script>
        function sauvegarderConfig(idArticle) {
            const methode = document.getElementById('methode_' + idArticle).value;
            const gestionLot = document.getElementById('gestionLot_' + idArticle).checked;
            const typePeremption = document.getElementById('typePeremption_' + idArticle).value;
            const delaiAlerte = document.getElementById('delaiAlerte_' + idArticle).value;
            
            const formData = new FormData();
            formData.append('idArticle', idArticle);
            formData.append('methodeValorisation', methode);
            formData.append('gestionLot', gestionLot);
            formData.append('typePeremption', typePeremption);
            if (delaiAlerte !== null && delaiAlerte !== undefined && String(delaiAlerte).trim() !== '') {
                formData.append('delaiAlerte', delaiAlerte);
            }
            
            fetch('${pageContext.request.contextPath}/gestionstock/configuration/save', {
                method: 'POST',
                body: formData
            })
            .then(async (response) => {
                const contentType = response.headers.get('content-type') || '';
                const raw = await response.text();
                if (!response.ok) {
                    throw new Error(raw || ('HTTP ' + response.status));
                }
                if (!contentType.includes('application/json')) {
                    throw new Error((raw || '').substring(0, 200));
                }
                return JSON.parse(raw);
            })
            .then(data => {
                if (data.success) {
                    alert('Configuration enregistrée avec succès!');
                    location.reload();
                } else {
                    alert('Erreur: ' + data.message);
                }
            })
            .catch(error => {
                alert('Erreur de communication: ' + error);
            });
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚙️ Configuration de la Valorisation</h1>
        </div>

        <div class="content">
            <table class="table">
                <thead>
                    <tr>
                        <th>Article</th>
                        <th>Méthode</th>
                        <th>Gestion Lot</th>
                        <th>Type Péremption</th>
                        <th>Délai Alerte (jours)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${articles}" var="article">
                        <c:set var="config" value="${configsMap[article.idArticle]}" />
                        <tr>
                            <td><strong>${article.designation}</strong></td>
                            <td>
                                <select id="methode_${article.idArticle}">
                                    <option value="FIFO" ${config != null && config.methodeValorisation == 'FIFO' ? 'selected' : ''}>
                                        FIFO
                                    </option>
                                    <option value="CMUP" ${config == null || config.methodeValorisation == 'CMUP' ? 'selected' : ''}>
                                        CMUP
                                    </option>
                                </select>
                            </td>
                            <td>
                                <input type="checkbox" id="gestionLot_${article.idArticle}"
                                       ${config != null && config.gestionLot ? 'checked' : ''} />
                            </td>
                            <td>
                                <select id="typePeremption_${article.idArticle}">
                                    <option value="">Aucun</option>
                                    <option value="DLC" ${config != null && config.typePeremption == 'DLC' ? 'selected' : ''}>
                                        DLC
                                    </option>
                                    <option value="DLUO" ${config != null && config.typePeremption == 'DLUO' ? 'selected' : ''}>
                                        DLUO
                                    </option>
                                </select>
                            </td>
                            <td>
                                <input type="number" id="delaiAlerte_${article.idArticle}" 
                                       value="${config != null ? config.delaiAlertePeremption : 30}" 
                                       min="0" max="365" />
                            </td>
                            <td>
                                <button class="btn" onclick="sauvegarderConfig(${article.idArticle})">
                                    Enregistrer
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div style="margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 5px;">
                <h3>📖 Guide de Configuration</h3>
                <p><strong>FIFO (First In First Out):</strong> Les lots les plus anciens sont consommés en premier. Idéal pour les produits périssables.</p>
                <p><strong>CMUP (Coût Moyen Pondéré):</strong> Le coût est moyenné sur tous les achats. Idéal pour les produits non périssables.</p>
                <p><strong>Gestion Lot:</strong> Active le suivi par lot avec numéro, dates de fabrication et péremption.</p>
                <p><strong>DLC:</strong> Date Limite de Consommation (produits frais, médicaments).</p>
                <p><strong>DLUO:</strong> Date Limite d'Utilisation Optimale (produits secs).</p>
            </div>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="${pageContext.request.contextPath}/gestionstock/dashboard" class="btn">← Retour au Tableau de Bord</a>
            </div>
        </div>
    </div>
</body>
</html>
