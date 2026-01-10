<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - BusinessSuite</title>
    <style>
        /* Variables CSS - Palette Oat Milk & Rich Burgundy */
        :root {
            --oat-milk: #FDF9F2;
            --oat-milk-dark: #F5F0E6;
            --burgundy: #7A051F;
            --burgundy-light: #8A1A2F;
            --burgundy-dark: #6A0015;
            --dark: #2C1810;
            --gray: #8C7E6E;
            --gray-light: #E8E0D5;
            --border-radius: 12px;
            --box-shadow: 0 8px 30px rgba(122, 5, 31, 0.08);
            --transition: all 0.3s ease;
        }

        /* Reset et styles de base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background: linear-gradient(135deg, var(--oat-milk) 0%, #FFFCF5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Conteneur principal */
        .container {
            width: 100%;
            max-width: 480px;
            margin: 0 auto;
        }

        /* Carte de connexion */
        .login-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 60px 50px;
            width: 100%;
            border: 1px solid var(--oat-milk-dark);
            position: relative;
        }

        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, var(--burgundy), var(--burgundy-dark));
            border-radius: var(--border-radius) var(--border-radius) 0 0;
        }

        /* En-tête */
        .login-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .login-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--burgundy);
            margin-bottom: 15px;
        }

        .login-subtitle {
            color: var(--gray);
            font-size: 1rem;
        }

        /* Formulaire */
        .login-form {
            margin-bottom: 40px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 0.95rem;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 16px 18px;
            border: 2px solid var(--gray-light);
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            background: var(--oat-milk);
            font-family: inherit;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        select:focus {
            outline: none;
            border-color: var(--burgundy);
            background: white;
            box-shadow: 0 0 0 3px rgba(122, 5, 31, 0.1);
        }

        /* Bouton de connexion */
        .login-btn {
            width: 100%;
            background: linear-gradient(135deg, var(--burgundy), var(--burgundy-dark));
            color: white;
            padding: 18px;
            border-radius: var(--border-radius);
            border: none;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 6px 20px rgba(122, 5, 31, 0.3);
            margin-top: 10px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(122, 5, 31, 0.4);
        }

        /* Lien d'annulation */
        .cancel-link {
            display: block;
            text-align: center;
            color: var(--gray);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
            padding: 12px;
            border: 2px solid transparent;
            border-radius: var(--border-radius);
        }

        .cancel-link:hover {
            color: var(--burgundy);
            border-color: var(--gray-light);
            background: var(--oat-milk);
        }

        /* Message d'erreur */
        .error-message {
            background: linear-gradient(135deg, var(--oat-milk), #FDF0F0);
            color: var(--burgundy);
            padding: 20px 25px;
            border-radius: var(--border-radius);
            margin-top: 30px;
            text-align: center;
            font-weight: 600;
            border: 2px solid var(--burgundy);
            border-left: 6px solid var(--burgundy);
        }

        /* Indicateur de sécurité */
        .security-indicator {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 30px;
            padding: 15px 20px;
            background: var(--oat-milk);
            border-radius: var(--border-radius);
            border-left: 4px solid var(--burgundy);
        }

        .security-dot {
            width: 8px;
            height: 8px;
            background: var(--burgundy);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .security-text {
            color: var(--gray);
            font-size: 0.85rem;
            font-weight: 500;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-card {
            animation: fadeInUp 0.6s ease-out;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .login-card {
                padding: 40px 30px;
            }
            
            .login-title {
                font-size: 1.8rem;
            }
        }

        @media (max-width: 480px) {
            .login-card {
                padding: 30px 20px;
            }
            
            .login-title {
                font-size: 1.6rem;
            }
            
            body {
                padding: 15px;
            }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="login-card">
            <div class="login-header">
                <h1 class="login-title">Connexion</h1>
                <p class="login-subtitle">Accès à l'application</p>
            </div>

            <form action="login" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">Email</label>
                    <select id="email" name="email" required style="width: 100%; padding: 16px 18px; border: 2px solid var(--gray-light); border-radius: var(--border-radius); font-size: 1rem; transition: var(--transition); background: var(--oat-milk); font-family: inherit;">
                        <option value="">Sélectionnez un email</option>
                        <c:forEach var="email" items="${emails}">
                            <option value="${email}">${email}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="motDePasse">Mot de passe</label>
                    <input type="password" id="motDePasse" name="motDePasse" value="" required>
                </div>

                <button type="submit" class="login-btn">Se connecter</button>
            </form>

            <a href="${pageContext.request.contextPath}/entrer" class="cancel-link">Annuler</a>

            <div class="security-indicator">
                <div class="security-dot"></div>
                <div class="security-text">Connexion sécurisée - Données cryptées</div>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
        </div>
    </div>
</body>
</html>