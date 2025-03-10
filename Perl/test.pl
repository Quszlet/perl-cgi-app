#!/usr/bin/perl
package test;

my test_string = qq{POST /tickets/0 HTTP/1.1
Host: localhost:8080
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br, zstd
Content-Type: multipart/form-data; boundary=----geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Length: 1818
Origin: http://localhost:8080
Connection: keep-alive
Referer: http://localhost:8080/tickets/tickets.cgi?flight_number=AB123
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: frame
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1
Priority: u=4

------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="first_name"

Павел
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="last_name"

Морозова
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="patronymic"

Геннадьевич
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="passport_series"

4444
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="passport_number"

777777
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="birth_date"


------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="email"

123@gmail.com
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="departure_date"

2025-05-15
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="arrival_date"

2025-05-15
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="departure_country"

Россия
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="departure_city"

Москва
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="arrival_country"

Франция
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name="arrival_city"

Париж
------geckoformboundaryde3551c7baeff233127a57a9c168acca
Content-Disposition: form-data; name=".submit"

Оформить билет
------geckoformboundaryde3551c7baeff233127a57a9c168acca--
};


