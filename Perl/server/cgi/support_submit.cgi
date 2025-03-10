#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;

# Получаем параметры формы
my $name  = $cgi->param('name')  || 'Пользователь';
my $email = $cgi->param('email') || 'ваш email';

print $cgi->start_html(
    -title => 'Сообщение отправлено',
    -style => { -code => '
        body { font-family: Arial, sans-serif; background: #f9f9f9; color: #333; margin: 20px; }
        .container { max-width: 600px; margin: auto; padding: 20px; background: #fff; border: 1px solid #ddd; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #005792; }
        p { text-align: center; font-size: 16px; }
        .button-container { text-align: center; margin-top: 20px; }
        input[type="submit"] { padding: 10px 20px; background: #005792; color: #fff; border: none; cursor: pointer; }
    ' }
);

print qq{
  <div class="container">
    <h1>$name, сообщение успешно отправлено в техническую поддержку! Ответ придет на вашу электронную почту $email.</h1>
    <p>Спасибо за ваше обращение!</p>
    <p>Хотите еще задать вопрос?</p>
    <div class="button-container">
      <form action="/support" method="POST">
        <input type="submit" value="Задать вопрос">
      </form>
    </div>
  </div>
};

print $cgi->end_html;
