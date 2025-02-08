#!/usr/bin/perl
package HTMLGenerator;

sub new {
    my ($class, %args) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub generate_main_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Моя Главная Страница</title>
        <style>
            body {
                background-color: #e8f4f8;
                font-family: Arial, sans-serif;
                padding: 20px;
                color: #2c3e50;
            }
            h1 {
                color: #2980b9;
            }
            ul {
                list-style-type: none;
                padding: 0;
            }
            li {
                margin: 10px 0;
            }
            a {
                color: #2980b9;
                text-decoration: none;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <h1>Добро пожаловать на главную страницу!</h1>
        <p>Здесь вы можете заказать авиабилеты и ознакомиться с расписанием рейсов.</p>
        <img src="/server/resource/airplane.png" alt="Самолет" width="300" style="display:block; margin: 0 auto;">
        <p>Выберите один из разделов ниже для продолжения:</p>
        <ul>
            <li><a href="/order" target="content">Заказать билет</a></li>
            <li><a href="/info" target="content">Информация о рейсах</a></li>
            <li><a href="/contacts" target="content">Контакты</a></li>
        </ul>
    </body>
</html>
HTML
    ;
    return $content;
}


# Функция генерирует страницу-шапку сайта
sub generate_header_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Шапка сайта</title>
        <style>
            body {
                background-image: url('images/header_bg.jpg');
                background-size: cover;
                color: white;
                text-align: center;
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <h1>Заказ авиабилетов</h1>
    </body>
</html>
HTML
    ;
    return $content;
}

# Функция генерирует страницу меню
sub generate_menu_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Меню сайта</title>
        <style>
            body {
                background-color: #f0f0f0;
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 10px;
            }
            a {
                display: block;
                margin: 10px 0;
                color: blue;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <h2>Навигация</h2>
        <a href="main.html" target="content">Главная страница</a>
        <a href="order.html" target="content">Заказ билета</a>
        <a href="flights.html" target="content">Информация о рейсах</a>
        <a href="contacts.html" target="content">Контакты</a>
    </body>
</html>
HTML
    ;
    return $content;
}

# Функция генерирует страницу основного содержимого (например, главную страницу контента)
sub generate_content_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Главная страница контента</title>
        <style>
            body {
                background-image: url('images/main_bg.jpg');
                background-size: cover;
                font-family: Arial, sans-serif;
                padding: 20px;
                color: #333;
            }
            table {
                border-collapse: collapse;
                width: 80%;
                margin: 20px auto;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }
            a {
                color: blue;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <a name="top"></a>
        <h1>Добро пожаловать на наш сайт!</h1>
        <p>Здесь вы можете заказать авиабилеты и ознакомиться с расписанием рейсов.</p>
        <img src="resource/airplane.png" alt="Самолет" width="300" style="display:block; margin: 0 auto;">
        <h2>Расписание рейсов</h2>
        <table>
            <tr>
                <th>Номер рейса</th>
                <th>Пункт отправления</th>
                <th>Пункт назначения</th>
                <th>Время вылета</th>
            </tr>
            <tr>
                <td>SU101</td>
                <td>Москва</td>
                <td>Нью-Йорк</td>
                <td>10:00</td>
            </tr>
            <tr>
                <td>SU202</td>
                <td>Москва</td>
                <td>Париж</td>
                <td>12:30</td>
            </tr>
        </table>
        <p>
            <a href="#top">На начало страницы</a> |
            <a href="#bottom">В конец страницы</a> |
            <a href="main.html" target="_top">На главную страницу</a>
        </p>
        <a name="bottom"></a>
    </body>
</html>
HTML
    ;
    return $content;
}

# Функция генерирует страницу заказа билета
sub generate_order_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Заказ билета</title>
        <style>
            body {
                background-image: url('images/order_bg.jpg');
                background-size: cover;
                font-family: Arial, sans-serif;
                color: #333;
                padding: 20px;
            }
            form {
                background: rgba(255,255,255,0.9);
                padding: 20px;
                max-width: 400px;
                margin: 0 auto;
                border-radius: 8px;
            }
            input, select {
                width: 100%;
                padding: 8px;
                margin: 10px 0;
            }
            a {
                color: blue;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <a name="top"></a>
        <h1>Заказ билета</h1>
        <p>Заполните форму ниже для заказа авиабилета.</p>
        <form action="submit_order.html" method="post">
            <label for="name">Ваше имя:</label><br>
            <input type="text" id="name" name="name" required><br>
            
            <label for="flight">Выберите рейс:</label><br>
            <select id="flight" name="flight">
                <option value="SU101">SU101 – Москва - Нью-Йорк</option>
                <option value="SU202">SU202 – Москва - Париж</option>
            </select><br>
            
            <label for="date">Дата вылета:</label><br>
            <input type="date" id="date" name="date" required><br>
            
            <input type="submit" value="Заказать">
        </form>
        <p>
            <a href="#top">На начало страницы</a> |
            <a href="#bottom">В конец страницы</a> |
            <a href="main.html" target="_top">На главную страницу</a>
        </p>
        <a name="bottom"></a>
    </body>
</html>
HTML
    ;
    return $content;
}

# Функция генерирует страницу информации о рейсах
sub generate_flights_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Информация о рейсах</title>
        <style>
            body {
                background-image: url('images/flights_bg.jpg');
                background-size: cover;
                font-family: Arial, sans-serif;
                color: #333;
                padding: 20px;
            }
            table {
                border-collapse: collapse;
                width: 90%;
                margin: 20px auto;
            }
            th, td {
                border: 1px solid #aaa;
                padding: 10px;
                text-align: center;
            }
            a {
                color: blue;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <a name="top"></a>
        <h1>Информация о рейсах</h1>
        <p>Здесь представлена информация о доступных рейсах и их расписании.</p>
        <table>
            <tr>
                <th>Номер рейса</th>
                <th>Пункт отправления</th>
                <th>Пункт назначения</th>
                <th>Дата и время</th>
            </tr>
            <tr>
                <td>SU101</td>
                <td>Москва</td>
                <td>Нью-Йорк</td>
                <td>10:00, 01.05.2025</td>
            </tr>
            <tr>
                <td>SU202</td>
                <td>Москва</td>
                <td>Париж</td>
                <td>12:30, 02.05.2025</td>
            </tr>
        </table>
        <p>
            <a href="#top">На начало страницы</a> |
            <a href="#bottom">В конец страницы</a> |
            <a href="main.html" target="_top">На главную страницу</a>
        </p>
        <a name="bottom"></a>
    </body>
</html>
HTML
    ;
    return $content;
}

# Функция генерирует страницу контактов
sub generate_contacts_page {
    my ($self) = @_;
    my $content = <<'HTML';
<html>
    <head>
        <meta charset="UTF-8">
        <title>Контакты</title>
        <style>
            body {
                background-image: url('images/contacts_bg.jpg');
                background-size: cover;
                font-family: Arial, sans-serif;
                color: #333;
                padding: 20px;
            }
            a {
                color: blue;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <a name="top"></a>
        <h1>Контакты</h1>
        <p>Свяжитесь с нами по следующим контактам:</p>
        <ul>
            <li>Телефон: +7 (495) 123-45-67</li>
            <li>Email: info@airtickets.example.com</li>
            <li>Адрес: Москва, ул. Примерная, д. 1</li>
        </ul>
        <p>
            <a href="#top">На начало страницы</a> |
            <a href="#bottom">В конец страницы</a> |
            <a href="main.html" target="_top">На главную страницу</a>
        </p>
        <a name="bottom"></a>
    </body>
</html>
HTML
    ;
    return $content;
}

1;  # Модуль должен вернуть истину