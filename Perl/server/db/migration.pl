#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use DBI;
use File::Spec::Functions qw(catfile);

# Функция для создания таблиц
sub create_all_tables {
    my ($dbh) = @_;

    my $sql_countries = <<'SQL';
CREATE TABLE IF NOT EXISTS Countries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);
SQL

    my $sql_cities = <<'SQL';
CREATE TABLE IF NOT EXISTS Cities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);
SQL

    my $sql_airlines = <<'SQL';
CREATE TABLE IF NOT EXISTS Airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    country_id INTEGER,
    logo BLOB,
    website TEXT,
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);
SQL

    my $sql_flights = <<'SQL';
CREATE TABLE IF NOT EXISTS Flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL,
    departure_city_id INTEGER NOT NULL,
    arrival_city_id INTEGER NOT NULL,
    departure_date TEXT NOT NULL,
    arrival_date TEXT NOT NULL,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    price REAL NOT NULL,
    available_tickets INTEGER NOT NULL,
    description TEXT,
    image BLOB,
    FOREIGN KEY (departure_city_id) REFERENCES Cities(id),
    FOREIGN KEY (arrival_city_id) REFERENCES Cities(id),
    FOREIGN KEY (airline_id) REFERENCES Airlines(id)
);
SQL

    my $sql_tickets = <<'SQL';
CREATE TABLE IF NOT EXISTS Tickets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_id INTEGER NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    patronymic TEXT,
    passport_series TEXT NOT NULL,
    passport_number TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    order_date TEXT NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(id)
);
SQL

    my $sql_support = <<'SQL';
CREATE TABLE IF NOT EXISTS SupportQuestions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT NOT NULL,
    user_email TEXT NOT NULL,
    question_text TEXT NOT NULL,
    question_date TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    answer_text TEXT
);
SQL

    $dbh->do($sql_countries) or die "Ошибка создания Countries: " . $dbh->errstr;
    $dbh->do($sql_cities) or die "Ошибка создания Cities: " . $dbh->errstr;
    $dbh->do($sql_airlines) or die "Ошибка создания Airlines: " . $dbh->errstr;
    $dbh->do($sql_flights) or die "Ошибка создания Flights: " . $dbh->errstr;
    $dbh->do($sql_tickets) or die "Ошибка создания Tickets: " . $dbh->errstr;
    $dbh->do($sql_support) or die "Ошибка создания SupportQuestions: " . $dbh->errstr;
    
    print "Все таблицы успешно созданы.\n";
}

# Вспомогательная функция для чтения бинарного файла
sub read_blob {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Cannot open $file_path: $!";
    binmode($fh);
    local $/;
    my $data = <$fh>;
    close $fh;
    return $data;
}

# Функция для проверки, есть ли данные в таблице
sub table_has_data {
    my ($dbh, $table) = @_;
    my $sth = $dbh->prepare("SELECT COUNT(*) FROM $table");
    $sth->execute();
    my ($count) = $sth->fetchrow_array;
    return $count > 0;
}

# Функция для вставки тестовых данных в таблицу Countries
sub insert_countries {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'Countries');
    my $insert_country = "INSERT OR IGNORE INTO Countries (name) VALUES (?)";
    my @countries = ("Россия", "США", "Япония", "Франция", "Австралия");
    foreach my $country (@countries) {
        $dbh->do($insert_country, undef, $country) or die $dbh->errstr;
    }
    print "Таблица Countries заполнена.\n";
}

# Функция для вставки тестовых данных в таблицу Cities
sub insert_cities {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'Cities');
    my $insert_city = "INSERT INTO Cities (name, country_id) VALUES (?, (SELECT id FROM Countries WHERE name = ?))";
    my @cities = (
        ["Москва", "Россия"],
        ["Нью-Йорк", "США"],
        ["Токио", "Япония"],
        ["Париж", "Франция"],
        ["Сидней", "Австралия"],
    );
    foreach my $city (@cities) {
        $dbh->do($insert_city, undef, @$city) or die $dbh->errstr;
    }
    print "Таблица Cities заполнена.\n";
}

# Функция для вставки тестовых данных в таблицу Airlines
sub insert_airlines {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'Airlines');
    my $insert_airline = "INSERT INTO Airlines (name, country_id, logo, website) VALUES (?, (SELECT id FROM Countries WHERE name = ?), ?, ?)";
    my @airlines = (
        [ "Aeroflot", "Россия", "server/resource/airline_logo1.png", "https://www.aeroflot.ru" ],
        [ "United Airlines", "США", "server/resource/airline_logo2.png", "https://www.united.com" ],
        [ "Japan Airlines", "Япония", "server/resource/airline_logo3.png", "https://www.jal.co.jp" ],
        [ "Air France", "Франция", "server/resource/airline_logo4.png", "https://www.airfrance.com" ],
        [ "Qantas", "Австралия", "server/resource/airline_logo5.png", "https://www.qantas.com" ],
    );
    foreach my $airline (@airlines) {
        my ($name, $country, $logo_file, $website) = @$airline;
        # my $logo_blob = read_blob($logo_file);
        $dbh->do($insert_airline, undef, $name, $country, undef, $website) #!!!!!
            or die "Ошибка вставки авиакомпании $name: " . $dbh->errstr;
    }
    print "Таблица Airlines заполнена.\n";
}

# Функция для вставки тестовых данных в таблицу Flights
sub insert_flights {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'Flights');
    my $insert_flight = qq{
        INSERT INTO Flights (
            flight_number,
            departure_city_id,
            arrival_city_id,
            departure_date,
            arrival_date,
            departure_time,
            arrival_time,
            airline_id,
            price,
            available_tickets,
            description,
            image
        ) VALUES (?, 
            (SELECT id FROM Cities WHERE name = ?), 
            (SELECT id FROM Cities WHERE name = ?),
            ?, ?, ?, ?, 
            (SELECT id FROM Airlines WHERE name = ?),
            ?, ?, ?, ?
        )
    };
    my @flights = (
        [ 'AB123', 'Москва', 'Париж', '2025-05-15', '2025-05-15', '10:00', '14:00', 'Aeroflot', 500, 100, 'Комфортный прямой рейс из Москвы в Париж', "../resource/flight1.jpg" ],
        [ 'CD456', 'Нью-Йорк', 'Париж', '2025-06-20', '2025-06-21', '09:00', '21:00', 'United Airlines', 700, 80, 'Рейс с пересадкой, удобное расписание', "../resource/flight2.jpg" ],
        [ 'EF789', 'Токио', 'Сидней', '2025-07-10', '2025-07-10', '11:30', '23:00', 'Japan Airlines', 800, 90, 'Надежный рейс для бизнес-поездок', "../resource/flight3.jpg" ],
        [ 'GH012', 'Париж', 'Москва', '2025-08-05', '2025-08-05', '08:15', '11:00', 'Air France', 150, 120, 'Экономичный рейс по Европе', "../resource/flight4.jpg" ],
        [ 'IJ345', 'Сидней', 'Токио', '2025-09-12', '2025-09-12', '07:00', '08:30', 'Qantas', 100, 150, 'Короткий рейс внутри Австралии', "../resource/flight5.jpg" ]
    );
    foreach my $flight (@flights) {
        my ($flight_number, $dep_city, $arr_city, $dep_date, $arr_date, $dep_time, $arr_time, $airline, $price, $tickets, $desc, $img_file) = @$flight;
        my $img_blob = read_blob($img_file);
        $dbh->do($insert_flight, undef, $flight_number, $dep_city, $arr_city, $dep_date, $arr_date, $dep_time, $arr_time, $airline, $price, $tickets, $desc, $img_blob)
            or die "Ошибка вставки рейса $flight_number: " . $dbh->errstr;
    }
    print "Таблица Flights заполнена.\n";
}

# Функция для вставки тестовых данных в таблицу Tickets
sub insert_tickets {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'Tickets');
    my $insert_ticket = qq{
        INSERT INTO Tickets (
            flight_id,
            first_name,
            last_name,
            patronymic,
            passport_series,
            passport_number,
            birth_date,
            order_date
        ) VALUES (
            (SELECT id FROM Flights WHERE flight_number = ?),
            ?, ?, ?, ?, ?, ?, ?
        )
    };
    my @tickets = (
        [ 'AB123', 'Иван', 'Иванов', 'Иванович', '1234', '567890', '1980-01-01', '2025-05-01' ],
        [ 'CD456', 'John', 'Doe', '', '4321', '098765', '1975-02-02', '2025-06-01' ],
        [ 'EF789', 'Taro', 'Yamada', '', '1111', '222222', '1985-03-03', '2025-07-01' ],
        [ 'GH012', 'Pierre', 'Dupont', '', '3333', '444444', '1990-04-04', '2025-08-01' ],
        [ 'IJ345', 'Bruce', 'Wayne', '', '5555', '666666', '1970-05-05', '2025-09-01' ]
    );
    foreach my $ticket (@tickets) {
        $dbh->do($insert_ticket, undef, @$ticket)
            or die "Ошибка вставки билета для рейса $ticket->[0]: " . $dbh->errstr;
    }
    print "Таблица Tickets заполнена.\n";
}

# Функция для вставки тестовых данных в таблицу SupportQuestions
sub insert_support_questions {
    my ($dbh) = @_;
    return if table_has_data($dbh, 'SupportQuestions');
    my $insert_support = qq{
        INSERT INTO SupportQuestions (
            user_name,
            user_email,
            question_text,
            question_date,
            status,
            answer_text
        ) VALUES (?, ?, ?, ?, ?, ?)
    };
    my @support = (
        [ 'Александр', 'alex@example.com', 'Как изменить бронирование?', '2025-05-10 10:00:00', 'pending', '' ],
        [ 'Мария', 'maria@example.com', 'Есть ли скидки для студентов?', '2025-05-11 11:00:00', 'pending', '' ],
        [ 'John', 'john@example.com', 'Как оплатить билет?', '2025-05-12 12:00:00', 'pending', '' ],
        [ 'Taro', 'taro@example.com', 'Можно ли изменить дату вылета?', '2025-05-13 13:00:00', 'pending', '' ],
        [ 'Pierre', 'pierre@example.com', 'Что делать, если рейс задерживается?', '2025-05-14 14:00:00', 'pending', '' ],
    );
    foreach my $sq (@support) {
        $dbh->do($insert_support, undef, @$sq)
            or die "Ошибка вставки вопроса техподдержки: " . $dbh->errstr;
    }
    print "Таблица SupportQuestions заполнена.\n";
}

# Функция для вставки всех тестовых данных
sub insert_all_test_data {
    my ($dbh) = @_;
    insert_countries($dbh);
    insert_cities($dbh);
    insert_airlines($dbh);
    insert_flights($dbh);
    insert_tickets($dbh);
    insert_support_questions($dbh);
    print "Все тестовые данные успешно вставлены.\n";
}

# Функция для очистки (удаления) таблиц
sub drop_all_tables {
    my ($dbh) = @_;
    
    # Удаляем таблицы в порядке, обратном зависимости внешних ключей
    my @tables = qw(SupportQuestions Tickets Flights Airlines Cities Countries);
    foreach my $table (@tables) {
        my $sql = "DROP TABLE IF EXISTS $table";
        $dbh->do($sql) or die "Ошибка удаления таблицы $table: " . $dbh->errstr;
        print "Таблица $table удалена.\n";
    }
}

# Основной блок
my $db_file = "airline.db";
my $dsn = "dbi:SQLite:dbname=$db_file";
my $dbh = DBI->connect($dsn, "", "", { RaiseError => 1, AutoCommit => 1 })
    or die $DBI::errstr;

my $create_tables   = 0;
my $insert_test     = 0;
my $clear_tables    = 0;

GetOptions(
    "create_tables"   => \$create_tables,
    "insert_test_data"=> \$insert_test,
    "clear_tables"    => \$clear_tables,
) or die "Неправильное использование\n";

if ($clear_tables) {
    drop_all_tables($dbh);
}

if ($create_tables) {
    create_all_tables($dbh);
}

if ($insert_test) {
    insert_all_test_data($dbh);
}

$dbh->disconnect;
