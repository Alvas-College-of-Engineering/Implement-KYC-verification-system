<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error - SecureBank</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .error-container {
                text-align: center;
                color: white;
                padding: 40px;
            }

            .error-code {
                font-size: 120px;
                font-weight: 800;
                margin-bottom: 20px;
            }

            .error-message {
                font-size: 24px;
                margin-bottom: 30px;
            }

            .btn {
                display: inline-block;
                padding: 12px 30px;
                background: #FFD700;
                color: #333;
                text-decoration: none;
                border-radius: 50px;
                font-weight: 600;
                transition: transform 0.3s;
            }

            .btn:hover {
                transform: translateY(-3px);
            }
        </style>
    </head>

    <body>
        <div class="error-container">
            <div class="error-code">😕</div>
            <div class="error-message">Something went wrong!</div>
            <p style="margin-bottom: 30px;">We're sorry, but an error occurred while processing your request.</p>
            <a href="${pageContext.request.contextPath}/" class="btn">Return to Home</a>
        </div>
    </body>

    </html>