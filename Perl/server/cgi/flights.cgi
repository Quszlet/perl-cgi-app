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

print STDERR "QUERY_STRING: " . ($ENV{QUERY_STRING} // '<undef>') . "\n";

# Получаем параметры фильтрации через CGI->param
my $dep_country = $cgi->param('departure_country') || "";
my $dep_city    = $cgi->param('departure_city')    || "";
my $arr_country = $cgi->param('arrival_country')   || "";
my $arr_city    = $cgi->param('arrival_city')      || "";
my $dep_date    = $cgi->param('departure_date')    || "";

print STDERR "departure_country: $dep_country\n";

my %criteria;
foreach my $param (qw(departure_country departure_city arrival_country arrival_city departure_date)) {
    my $val = $cgi->param($param);
    $criteria{$param} = $val if defined $val && $val ne '';
}



# Подключение к базе данных (файл базы находится на уровне с папкой cgi)
my $db_file = "server/db/airline.db";
my $dsn = "dbi:SQLite:dbname=$db_file";
my $dbh = DBI->connect($dsn, "", "", { RaiseError => 1, AutoCommit => 1 })
    or die $DBI::errstr;

# Создаем объект Repository и AirFlightsService
my $repo = Repository->new(dbh => $dbh);
my $air_flights_service = AirFlightsService->new(repository => $repo);

# Получаем список рейсов согласно фильтрам
my $flights;
if (%criteria) {
    print STDERR "Применяем фильтры: " . join(", ", map { "$_ = $criteria{$_}" } keys %criteria) . "\n";
    $flights = $air_flights_service->filter_flights(\%criteria);
} else {
    print STDERR "Получаем все рейсы\n";
    $flights = $air_flights_service->get_all_flights();
}


# Начало HTML-документа
print <<"HTML";
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Список авиарейсов</title>
  <style>
    body { 
      font-family: Arial, sans-serif; 
      margin: 20px; 
      background: url('images/background.jpg') no-repeat center top; 
      background-size: cover;
    }
    header { text-align: center; padding: 10px; }
    header img { max-width: 200px; }
    nav { margin: 20px 0; text-align: center; }
    nav a { margin: 0 10px; text-decoration: none; color: #005792; font-weight: bold; }
    h1 { color: #005792; }
    form { 
      margin-bottom: 20px; 
      padding: 10px; 
      background: #ffffffcc; 
      border: 1px solid #ddd; 
    }
    label { display: inline-block; width: 180px; margin-bottom: 10px; }
    select, input[type="date"] { padding: 5px; width: 220px; }
    input[type="submit"], input[type="reset"] {
      width: auto; 
      background: #005792; 
      color: #fff;
      border: none; 
      cursor: pointer; 
      margin-right: 10px; 
      padding: 6px 12px;
    }
    table { border-collapse: collapse; width: 100%; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #005792; color: #fff; }
    tr:nth-child(even) { background-color: #f2f2f2; }
    tr:hover { background-color: #ddd; }
    .flight-detail { margin-top: 30px; padding: 10px; background: #ffffffcc; border: 1px solid #ddd; }
    .flight-detail img { max-width: 300px; display: block; margin-bottom: 10px; }
    footer { text-align: center; margin-top: 20px; font-size: 14px; }
  </style>
  <script>
    // Функция для загрузки списка стран через HTTP-запрос к серверу
  async function loadCountries() {
    try {
      const response = await fetch('http://localhost:8080/location/country');
      if (!response.ok) throw new Error('Ошибка при загрузке стран');
      const countries = await response.json();
      populateCountrySelects(countries);
    } catch (error) {
      console.error('Ошибка загрузки стран:', error);
    }
  }

  // Функция для загрузки городов по выбранной стране через запрос к LocationRouter
  async function loadCities(country, targetSelectId) {
    try {
      const response = await fetch('http://localhost:8080/location/cities/' + encodeURIComponent(country));
      if (!response.ok) throw new Error('Ошибка при загрузке городов для ' + country);
      const cities = await response.json();
      populateCitySelect(targetSelectId, cities);
    } catch (error) {
      console.error('Ошибка загрузки городов:', error);
    }
  }


    function populateCountrySelects(countries) {
      const depSelect = document.getElementById('departure_country');
      const arrSelect = document.getElementById('arrival_country');
      depSelect.innerHTML = '<option value="">--Выберите страну--</option>';
      arrSelect.innerHTML = '<option value="">--Выберите страну--</option>';
      countries.forEach(country => {
        const opt1 = document.createElement('option');
        opt1.value = country;
        opt1.innerHTML = country;
        if (country === "$dep_country") opt1.selected = true;
        depSelect.appendChild(opt1);
        
        const opt2 = document.createElement('option');
        opt2.value = country;
        opt2.innerHTML = country;
        if (country === "$arr_country") opt2.selected = true;
        arrSelect.appendChild(opt2);
      });
      if (depSelect.value) loadCities(depSelect.value, 'departure_city');
      if (arrSelect.value) loadCities(arrSelect.value, 'arrival_city');
    }

   function populateCitySelect(selectId, cities) {
      const citySelect = document.getElementById(selectId);
      citySelect.innerHTML = '<option value="">--Выберите город--</option>';
      cities.forEach(city => {
        const opt = document.createElement('option');
        opt.value = city;
        opt.innerHTML = city;
        citySelect.appendChild(opt);
      });
      // Если для этого селекта уже есть выбранное значение, устанавливаем его
      if (selectId === 'departure_city' && "$dep_city") {
          citySelect.value = "$dep_city";
      }
      if (selectId === 'arrival_city' && "$arr_city") {
          citySelect.value = "$arr_city";
      }
    }

    window.onload = function() {
      loadCountries();

      document.getElementById('departure_country').onchange = function() {
          if (this.value) loadCities(this.value, 'departure_city');
      };

      document.getElementById('arrival_country').onchange = function() {
          if (this.value) loadCities(this.value, 'arrival_city');
      };
    };
  </script>
</head>
<body>
  <nav>
    <a href="#top">На начало страницы</a> |
    <a href="#filter">По фильтру</a> |
    <a href="#results">К таблице</a> |
    <a href="#details">К описанию рейсов</a> |
    <a href="/mainpage.html" target="_top">Главная страница</a> |
    <a href="#bottom">В конец страницы</a>
  </nav>
  <a name="top"></a>
  <header>
    <img src="/airline_logo.png" alt="Логотип">
    <h1>Список авиарейсов</h1>
    <p>Здесь отображается таблица авиарейсов, подходящих под выбранные фильтры.</p>
  </header>
  
  <section id="filter">
    <h2>Фильтр авиарейсов</h2>
    <form action="/flights/flights.cgi" method="GET">
      <label for="departure_country">Страна отправления:</label>
      <select name="departure_country" id="departure_country">
        <option value="">--Выберите страну--</option>
      </select><br><br>
      
      <label for="departure_city">Город отправления:</label>
      <select name="departure_city" id="departure_city">
        <option value="">--Выберите город--</option>
      </select><br><br>
      
      <label for="arrival_country">Страна прибытия:</label>
      <select name="arrival_country" id="arrival_country">
        <option value="">--Выберите страну--</option>
      </select><br><br>
      
      <label for="arrival_city">Город прибытия:</label>
      <select name="arrival_city" id="arrival_city">
        <option value="">--Выберите город--</option>
      </select><br><br>
      
      <label for="departure_date">Дата отправления:</label>
      <input type="date" name="departure_date" id="departure_date" value="$dep_date"><br><br>
      
      <input type="submit" value="Найти рейсы">
      <input type="reset" value="Очистить">
    </form>
  </section>
  
  <section id="results">
    <h2>Таблица авиарейсов</h2>
HTML

if (scalar(@$flights) == 0) {
    print "<p style='text-align:center;'>Авиарейсы не найдены</p>\n";
} else {
    print <<"HTML";
    <table>
      <thead>
        <tr>
          <th>Номер рейса</th>
          <th>Откуда</th>
          <th>Куда</th>
          <th>Дата отправления</th>
          <th>Дата прибытия</th>
          <th>Время отправления</th>
          <th>Время прибытия</th>
          <th>Авиакомпания</th>
          <th>Цена</th>
        </tr>
      </thead>
      <tbody>
HTML
 foreach my $flight (@$flights) {
    my $url = "/tickets/tickets.cgi?flight_number=" . uri_escape($flight->{flight_number} // '');
    print "<tr onclick=\"window.location='$url';\" style=\"cursor:pointer;\">";
    print "<td>" . ($flight->{flight_number} // '') . "</td>";
    print "<td>" . ($flight->{departure_city} // '') . "</td>";
    print "<td>" . ($flight->{arrival_city} // '') . "</td>";
    print "<td>" . ($flight->{departure_date} // '') . "</td>";
    print "<td>" . ($flight->{arrival_date} // '') . "</td>";
    print "<td>" . ($flight->{departure_time} // '') . "</td>";
    print "<td>" . ($flight->{arrival_time} // '') . "</td>";
    print "<td>" . ($flight->{airline} // '') . "</td>";
    print "<td>" . ($flight->{price} // '') . "</td>";
    print "</tr>\n";
  }


  print <<"HTML";
      </tbody>
    </table>
  </section>
  
  <section id="details">
    <h2>Описание и изображения рейсов</h2>
HTML
  foreach my $flight (@$flights) {
    my $img_data = $flight->{image} // "";
    my $encoded_img = $img_data ? "data:image/jpeg;base64," . encode_base64($img_data, "") : "";
    print qq{
      <div class="flight-detail">
        <h3>Рейс $flight->{flight_number} – $flight->{airline}</h3>
        <p>$flight->{description}</p>
    };
    if ($encoded_img) {
        print qq{<img src="$encoded_img" alt="Изображение рейса $flight->{flight_number}" style="max-width:300px;">};
    }
    print "</div>\n";
  }
}


print <<"HTML";
  </section>
  
  <footer id="bottom">
    <nav>
      <a href="#top">Наверх</a> |
      <a href="#filter">К фильтру</a> |
      <a href="#results">К таблице</a> |
      <a href="#details">К описанию</a> |
      <a href="/mainpage.html" target="_top">Главная страница</a>
    </nav>
    <p>&copy; 2025 Заказ авиабилетов</p>
  </footer>
</body>
</html>
HTML

$dbh->disconnect;
