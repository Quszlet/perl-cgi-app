#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use MIME::Base64;
use URI::Escape;

# Подключаем необходимые модули из наших директорий
use lib 'server/service';
use lib 'server/repository';
use Repository;
use AirFlightsService;

my $cgi = CGI->new;

# Получаем параметр flight_number для поиска рейса
my $flight_number = $cgi->param('flight_number') || "";

# Инициализируем переменные для предзаполнения данных рейса
my ($dep_date, $arr_date, $dep_city, $dep_country, $arr_city, $arr_country) = ("","","","","","");
my $flight;  # сохраним полный хэш рейса

if ($flight_number) {
    # Подключаемся к базе данных (файл базы находится на уровне с папкой cgi)
    my $db_file = "server/db/airline.db";
    my $dsn = "dbi:SQLite:dbname=$db_file";
    my $dbh = DBI->connect($dsn, "", "", { RaiseError => 1, AutoCommit => 1 })
        or die $DBI::errstr;
    
    # Создаем объект Repository и AirFlightsService
    my $repo = Repository->new(dbh => $dbh);
    my $air_flights_service = AirFlightsService->new(repository => $repo);
    
    # Получаем данные рейса по flight_number
    $flight = $air_flights_service->get_flight($flight_number);
    if ($flight && ref $flight eq 'HASH') {
        $dep_date     = $flight->{departure_date}    // "";
        $arr_date     = $flight->{arrival_date}      // "";
        $dep_city     = $flight->{departure_city}      // "";
        $dep_country  = $flight->{departure_country}   // "";
        $arr_city     = $flight->{arrival_city}        // "";
        $arr_country  = $flight->{arrival_country}     // "";
    }
    $dbh->disconnect;
}

print $cgi->start_html(
    -title => 'Оформление билета',
    -style => { -code => '
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background: url("images/background.jpg") no-repeat center top; 
            background-size: cover;
            color: #333;
        }
        header { text-align: center; margin-bottom: 20px; }
        header img { max-width: 150px; }
        nav { text-align: center; margin-bottom: 20px; }
        nav a { margin: 0 10px; text-decoration: none; color: #005792; font-weight: bold; }
        .form-container {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
        }
        .left-col, .right-col {
            flex: 1;
            min-width: 280px;
        }
        .field-row {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .field-row label {
            width: 140px;
            margin-right: 10px;
            text-align: right;
        }
        .field-row input {
            flex: 1;
            padding: 5px;
        }
        .no-click {
            pointer-events: none;
            background-color: #eaeaea;
        }
        form {
            background: #ffffffcc;
            padding: 15px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }
        input[type="submit"] {
            background: #005792;
            color: #fff;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            margin-top: 10px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th { background-color: #005792; color: #fff; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        footer { text-align: center; margin-top: 20px; font-size: 14px; }
    ' }
);

# Верхняя навигация
print qq{
  <nav>
    <a href="#top">На начало</a> |
    <a href="#form_section">К оформлению</a> |
    <a href="#table_section">К таблице</a> |
    <a href="#images_section">К изображениям</a> |
    <a href="/mainpage.html" target="_top">Главная страница</a> |
    <a href="#bottom">В конец</a>
  </nav>
};

print qq{<a name="top"></a>};

# Заголовок и логотип
print qq{
  <header>
    <img src="/airline_logo.png" alt="Логотип">
    <h1>Оформление билета</h1>
    <p>Заполните форму для оформления авиабилета. Данные о выбранном рейсе подставляются автоматически.</p>
  </header>
};

# Форма оформления билета
print qq{<a name="form_section"></a>};
print $cgi->start_form(-method => 'POST', -action => '/tickets/submit' -enctype => 'application/x-www-form-urlencoded');

# Контейнер с двумя колонками
print qq{<div class="form-container">};

# Левая колонка: поля, которые заполняет пользователь
print qq{<div class="left-col">};

print qq{<div class="field-row">};
print qq{<label>Имя:</label>};
print $cgi->textfield(
  -name => 'first_name',
  -default => 'Павел');
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Фамилия:</label>};
print $cgi->textfield(
  -name => 'last_name',
  -default => 'Морозова'
  );
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Отчество:</label>};
print $cgi->textfield(
  -name => 'patronymic',
  -default => 'Геннадьевич'
  );
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Серия паспорта:</label>};
print $cgi->textfield(
  -name => 'passport_series',
  -default => '4444'
  );
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Номер паспорта:</label>};
print $cgi->textfield(
  -name => 'passport_number',
  -default => '777777'
  );
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Дата рождения:</label>};
print qq{<input type="date" name="birth_date" id="birth_date">};
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Email:</label>};
print $cgi->textfield(
  -name => 'email',
  -default => '123@gmail.com'
  );
print qq{</div>};

print qq{</div>}; # Закрываем левую колонку

# Правая колонка: поля рейса (readonly, no-click)
print qq{<div class="right-col">};

print qq{<div class="field-row">};
print qq{<label>Дата отправления:</label>};
print $cgi->textfield(
    -name    => 'departure_date',
    -default => $dep_date,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Дата прибытия:</label>};
print $cgi->textfield(
    -name    => 'arrival_date',
    -default => $arr_date,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Страна отправления:</label>};
print $cgi->textfield(
    -name    => 'departure_country',
    -default => $dep_country,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Город отправления:</label>};
print $cgi->textfield(
    -name    => 'departure_city',
    -default => $dep_city,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Страна прибытия:</label>};
print $cgi->textfield(
    -name    => 'arrival_country',
    -default => $arr_country,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{<div class="field-row">};
print qq{<label>Город прибытия:</label>};
print $cgi->textfield(
    -name    => 'arrival_city',
    -default => $arr_city,
    -readonly => 1,
    -class   => 'no-click'
);
print qq{</div>};

print qq{</div>}; # Закрываем правую колонку

print qq{</div>}; # Закрываем form-container

print $cgi->submit(-value => 'Оформить билет');
print $cgi->end_form;

# Таблица с информацией о рейсе (для подтверждения выбора)
print qq{<a name="table_section"></a>};
print qq{
  <h2>Информация о выбранном рейсе</h2>
  <table>
    <thead>
      <tr>
        <th>Номер рейса</th>
        <th>Страна отправления</th>
        <th>Город отправления</th>
        <th>Страна прибытия</th>
        <th>Город прибытия</th>
        <th>Дата отправления</th>
        <th>Дата прибытия</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>$flight_number</td>
        <td>$dep_country</td>
        <td>$dep_city</td>
        <td>$arr_country</td>
        <td>$arr_city</td>
        <td>$dep_date</td>
        <td>$arr_date</td>
      </tr>
    </tbody>
  </table>
};

# Секция описания и изображений рейса (аналогично flights.cgi)
print qq{<a name="details"></a>};
print qq{
  <section id="details">
    <h2>Описание и изображения рейса</h2>
};
if (defined $flight && ref $flight eq 'HASH') {
    my $img_data = $flight->{image} // "";
    my $encoded_img = $img_data ? "data:image/jpeg;base64," . encode_base64($img_data, "") : "";
    print qq{
      <div class="flight-detail">
        <h3>Рейс $flight_number – $flight->{airline}</h3>
        <p>$flight->{description}</p>
    };
    if ($encoded_img) {
        print qq{<img src="$encoded_img" alt="Изображение рейса $flight_number" style="max-width:300px;">};
    }
    print "</div>\n";
}
print qq{</section>};

# Нижняя навигация
print qq{
  <footer id="bottom">
    <nav>
      <a href="#top">Наверх</a> |
      <a href="#form_section">К форме</a> |
      <a href="#table_section">К таблице</a> |
      <a href="#images_section">К изображениям</a> |
      <a href="/mainpage.html" target="_top">Главная страница</a>
    </nav>
    <p>&copy; 2025 Заказ авиабилетов</p>
  </footer>
};

print $cgi->end_html;
