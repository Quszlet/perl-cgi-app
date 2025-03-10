{"vars":[{"kind":12,"range":{"start":{"line":6,"character":0},"end":{"character":9999,"line":13}},"detail":"($class,%args)","definition":"sub","name":"new","signature":{"documentation":"","label":"new($class,%args)","parameters":[{"label":"$class"},{"label":"%args"}]},"children":[{"definition":"my","localvar":"my","kind":13,"containerName":"new","line":7,"name":"$class"},{"kind":13,"name":"%args","containerName":"new","line":7},{"kind":13,"localvar":"my","definition":"my","name":"$self","containerName":"new","line":8},{"line":9,"containerName":"new","name":"$args","kind":13},{"name":"$self","kind":13,"line":11,"containerName":"new"},{"name":"$class","kind":13,"line":11,"containerName":"new"},{"line":12,"containerName":"new","name":"$self","kind":13}],"containerName":"main::","line":6},{"line":7,"containerName":"","name":"warnings","kind":2},{"line":9,"name":"db","kind":12},{"line":9,"name":"dbh","kind":12},{"definition":"sub","detail":"($self)","range":{"start":{"line":16,"character":0},"end":{"line":50,"character":9999}},"kind":12,"line":16,"containerName":"main::","signature":{"documentation":" \u00d0\u009c\u00d0\u00b5\u00d1\u0082\u00d0\u00be\u00d0\u00b4 \u00d0\u00bf\u00d0\u00be\u00d0\u00bb\u00d1\u0083\u00d1\u0087\u00d0\u00b5\u00d0\u00bd\u00d0\u00b8\u00d1\u008f \u00d0\u00b2\u00d1\u0081\u00d0\u00b5\u00d1\u0085 \u00d1\u0080\u00d0\u00b5\u00d0\u00b9\u00d1\u0081\u00d0\u00be\u00d0\u00b2","parameters":[{"label":"$self"}],"label":"get_all_flights($self)"},"children":[{"name":"$self","containerName":"get_all_flights","line":17,"kind":13,"definition":"my","localvar":"my"},{"localvar":"my","definition":"my","kind":13,"containerName":"get_all_flights","line":19,"name":"$sql"},{"definition":"my","localvar":"my","kind":13,"containerName":"get_all_flights","line":42,"name":"$sth"},{"containerName":"get_all_flights","line":42,"kind":13,"name":"$self"},{"kind":12,"name":"prepare","containerName":"get_all_flights","line":42},{"line":42,"containerName":"get_all_flights","name":"$sql","kind":13},{"name":"$sth","kind":13,"line":43,"containerName":"get_all_flights"},{"kind":12,"name":"execute","containerName":"get_all_flights","line":43},{"line":45,"containerName":"get_all_flights","name":"@flights","localvar":"my","definition":"my","kind":13},{"kind":13,"localvar":"my","definition":"my","name":"$row","line":46,"containerName":"get_all_flights"},{"line":46,"containerName":"get_all_flights","name":"$sth","kind":13},{"containerName":"get_all_flights","line":46,"kind":12,"name":"fetchrow_hashref"},{"containerName":"get_all_flights","line":47,"kind":13,"name":"@flights"},{"containerName":"get_all_flights","line":47,"kind":13,"name":"$row"},{"kind":13,"name":"@flights","containerName":"get_all_flights","line":49}],"name":"get_all_flights"},{"line":42,"name":"db","kind":12},{"definition":"sub","detail":"($self,$criteria)","range":{"end":{"character":9999,"line":116},"start":{"character":0,"line":53}},"kind":12,"line":53,"containerName":"main::","signature":{"documentation":"","parameters":[{"label":"$self"},{"label":"$criteria"}],"label":"filter_flights($self,$criteria)"},"children":[{"name":"$self","containerName":"filter_flights","line":54,"kind":13,"localvar":"my","definition":"my"},{"name":"$criteria","kind":13,"line":54,"containerName":"filter_flights"},{"name":"@conditions","containerName":"filter_flights","line":56,"kind":13,"definition":"my","localvar":"my"},{"kind":13,"definition":"my","localvar":"my","name":"@params","line":57,"containerName":"filter_flights"},{"containerName":"filter_flights","line":60,"kind":13,"name":"$criteria"},{"name":"@conditions","kind":13,"line":61,"containerName":"filter_flights"},{"containerName":"filter_flights","line":62,"kind":13,"name":"@params"},{"kind":13,"name":"$criteria","containerName":"filter_flights","line":62},{"kind":13,"name":"$criteria","containerName":"filter_flights","line":64},{"kind":13,"name":"@conditions","containerName":"filter_flights","line":65},{"line":66,"containerName":"filter_flights","name":"@params","kind":13},{"kind":13,"name":"$criteria","containerName":"filter_flights","line":66},{"line":68,"containerName":"filter_flights","name":"$criteria","kind":13},{"containerName":"filter_flights","line":69,"kind":13,"name":"@conditions"},{"line":70,"containerName":"filter_flights","name":"@params","kind":13},{"containerName":"filter_flights","line":70,"kind":13,"name":"$criteria"},{"kind":13,"name":"$criteria","containerName":"filter_flights","line":72},{"kind":13,"name":"@conditions","containerName":"filter_flights","line":73},{"line":74,"containerName":"filter_flights","name":"@params","kind":13},{"containerName":"filter_flights","line":74,"kind":13,"name":"$criteria"},{"containerName":"filter_flights","line":76,"kind":13,"name":"$criteria"},{"kind":13,"name":"@conditions","containerName":"filter_flights","line":77},{"name":"@params","kind":13,"line":78,"containerName":"filter_flights"},{"containerName":"filter_flights","line":78,"kind":13,"name":"$criteria"},{"kind":13,"localvar":"my","definition":"my","name":"$where","containerName":"filter_flights","line":82},{"name":"@conditions","kind":13,"line":82,"containerName":"filter_flights"},{"name":"@conditions","kind":13,"line":82,"containerName":"filter_flights"},{"definition":"my","localvar":"my","kind":13,"line":84,"containerName":"filter_flights","name":"$sql"},{"line":108,"containerName":"filter_flights","name":"$sth","localvar":"my","definition":"my","kind":13},{"containerName":"filter_flights","line":108,"kind":13,"name":"$self"},{"line":108,"containerName":"filter_flights","name":"prepare","kind":12},{"containerName":"filter_flights","line":108,"kind":13,"name":"$sql"},{"kind":13,"name":"$sth","containerName":"filter_flights","line":109},{"line":109,"containerName":"filter_flights","name":"execute","kind":12},{"kind":13,"name":"@params","containerName":"filter_flights","line":109},{"name":"@flights","line":111,"containerName":"filter_flights","kind":13,"definition":"my","localvar":"my"},{"name":"$row","containerName":"filter_flights","line":112,"kind":13,"localvar":"my","definition":"my"},{"name":"$sth","kind":13,"line":112,"containerName":"filter_flights"},{"containerName":"filter_flights","line":112,"kind":12,"name":"fetchrow_hashref"},{"containerName":"filter_flights","line":113,"kind":13,"name":"@flights"},{"containerName":"filter_flights","line":113,"kind":13,"name":"$row"},{"name":"@flights","kind":13,"line":115,"containerName":"filter_flights"}],"name":"filter_flights"},{"line":60,"name":"departure_country","kind":12},{"kind":12,"name":"departure_country","line":62},{"kind":12,"name":"departure_city","line":64},{"line":66,"kind":12,"name":"departure_city"},{"name":"arrival_country","kind":12,"line":68},{"kind":12,"name":"arrival_country","line":70},{"line":72,"kind":12,"name":"arrival_city"},{"name":"arrival_city","kind":12,"line":74},{"name":"departure_date","kind":12,"line":76},{"line":78,"name":"departure_date","kind":12},{"line":108,"name":"db","kind":12},{"line":118,"containerName":"main::","name":"get_flight","signature":{"documentation":"","label":"get_flight($self,$flight_number)","parameters":[{"label":"$self"},{"label":"$flight_number"}]},"children":[{"containerName":"get_flight","line":119,"name":"$self","definition":"my","localvar":"my","kind":13},{"line":119,"containerName":"get_flight","name":"$flight_number","kind":13},{"name":"$sql","containerName":"get_flight","line":121,"kind":13,"localvar":"my","definition":"my"},{"definition":"my","localvar":"my","kind":13,"containerName":"get_flight","line":145,"name":"$sth"},{"containerName":"get_flight","line":145,"kind":13,"name":"$self"},{"name":"prepare","kind":12,"line":145,"containerName":"get_flight"},{"kind":13,"name":"$sql","containerName":"get_flight","line":145},{"name":"$sth","kind":13,"line":146,"containerName":"get_flight"},{"containerName":"get_flight","line":146,"kind":12,"name":"execute"},{"containerName":"get_flight","line":146,"kind":13,"name":"$flight_number"},{"name":"$row","containerName":"get_flight","line":147,"kind":13,"localvar":"my","definition":"my"},{"kind":13,"name":"$sth","containerName":"get_flight","line":147},{"containerName":"get_flight","line":147,"kind":12,"name":"fetchrow_hashref"},{"line":148,"containerName":"get_flight","name":"$row","kind":13}],"definition":"sub","detail":"($self,$flight_number)","range":{"end":{"line":149,"character":9999},"start":{"character":0,"line":118}},"kind":12},{"line":145,"name":"db","kind":12}],"version":5}