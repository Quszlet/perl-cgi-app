{"vars":[{"containerName":"","line":6,"kind":2,"name":"Encode"},{"name":"new","detail":"($class,%args)","children":[{"name":"$class","localvar":"my","line":10,"containerName":"new","kind":13,"definition":"my"},{"containerName":"new","line":10,"kind":13,"name":"%args"},{"line":12,"kind":13,"containerName":"new","name":"$args"},{"name":"$self","localvar":"my","kind":13,"line":14,"containerName":"new","definition":"my"},{"line":15,"containerName":"new","kind":13,"name":"$args"},{"line":17,"kind":13,"containerName":"new","name":"$self"},{"containerName":"new","line":17,"kind":13,"name":"$class"},{"name":"$self","line":18,"kind":13,"containerName":"new"}],"signature":{"parameters":[{"label":"$class"},{"label":"%args"}],"label":"new($class,%args)","documentation":""},"containerName":"main::","kind":12,"definition":"sub","line":9,"range":{"end":{"line":19,"character":9999},"start":{"line":9,"character":0}}},{"name":"Dumper","line":10,"kind":2,"containerName":"Data"},{"name":"repository","kind":12,"line":12},{"name":"repository","kind":12,"line":15},{"name":"repository","line":15,"kind":12},{"kind":12,"containerName":"main::","definition":"sub","line":22,"signature":{"documentation":" \u00d0\u009c\u00d0\u00b5\u00d1\u0082\u00d0\u00be\u00d0\u00b4 get_countries \u00d0\u00b2\u00d0\u00be\u00d0\u00b7\u00d0\u00b2\u00d1\u0080\u00d0\u00b0\u00d1\u0089\u00d0\u00b0\u00d0\u00b5\u00d1\u0082 \u00d1\u0081\u00d0\u00bf\u00d0\u00b8\u00d1\u0081\u00d0\u00be\u00d0\u00ba \u00d0\u00b2\u00d1\u0081\u00d0\u00b5\u00d1\u0085 \u00d1\u0081\u00d1\u0082\u00d1\u0080\u00d0\u00b0\u00d0\u00bd \u00d0\u00b2 \u00d1\u0084\u00d0\u00be\u00d1\u0080\u00d0\u00bc\u00d0\u00b0\u00d1\u0082\u00d0\u00b5 JSON","parameters":[{"label":"$self"}],"label":"get_countries($self)"},"range":{"end":{"character":9999,"line":36},"start":{"character":0,"line":22}},"name":"get_countries","detail":"($self)","children":[{"kind":13,"definition":"my","containerName":"get_countries","line":23,"localvar":"my","name":"$self"},{"name":"$countries","localvar":"my","definition":"my","kind":13,"line":24,"containerName":"get_countries"},{"line":24,"kind":13,"containerName":"get_countries","name":"$self"},{"line":24,"containerName":"get_countries","kind":12,"name":"get_all_countries"},{"kind":13,"definition":"my","containerName":"get_countries","line":27,"localvar":"my","name":"@utf8_countries"},{"containerName":"get_countries","line":27,"kind":13,"name":"$countries"},{"kind":13,"line":31,"containerName":"get_countries","definition":"my","localvar":"my","name":"$json"},{"kind":12,"line":31,"containerName":"get_countries","name":"new"},{"line":31,"containerName":"get_countries","kind":12,"name":"utf8"},{"name":"encode","containerName":"get_countries","line":31,"kind":12},{"name":"@utf8_countries","kind":13,"line":31,"containerName":"get_countries"},{"name":"$json","line":35,"containerName":"get_countries","kind":13}]},{"name":"repository","line":24,"kind":12},{"line":24,"kind":12,"name":"location_repo"},{"line":27,"kind":12,"name":"decode_utf8"},{"line":31,"kind":12,"name":"JSON"},{"detail":"($self,$country)","children":[{"name":"$self","localvar":"my","kind":13,"containerName":"get_cities_by_country","definition":"my","line":40},{"name":"$country","containerName":"get_cities_by_country","line":40,"kind":13},{"containerName":"get_cities_by_country","kind":13,"line":41,"definition":"my","name":"$cities","localvar":"my"},{"containerName":"get_cities_by_country","line":41,"kind":13,"name":"$self"},{"kind":12,"line":41,"containerName":"get_cities_by_country","name":"get_cities_by_country"},{"line":41,"kind":13,"containerName":"get_cities_by_country","name":"$country"},{"definition":"my","containerName":"get_cities_by_country","kind":13,"line":44,"name":"@utf8_cities","localvar":"my"},{"name":"$cities","containerName":"get_cities_by_country","line":44,"kind":13},{"line":45,"containerName":"get_cities_by_country","kind":13,"name":"$JSON"},{"line":45,"kind":12,"containerName":"get_cities_by_country","name":"new"},{"line":45,"kind":12,"containerName":"get_cities_by_country","name":"utf8"},{"name":"encode","kind":12,"line":45,"containerName":"get_cities_by_country"},{"line":45,"containerName":"get_cities_by_country","kind":13,"name":"@utf8_cities"}],"name":"get_cities_by_country","range":{"start":{"line":39,"character":0},"end":{"line":46,"character":9999}},"line":39,"kind":12,"definition":"sub","containerName":"main::","signature":{"label":"get_cities_by_country($self,$country)","parameters":[{"label":"$self"},{"label":"$country"}],"documentation":" \u00d0\u009c\u00d0\u00b5\u00d1\u0082\u00d0\u00be\u00d0\u00b4 get_cities_by_country \u00d0\u00b2\u00d0\u00be\u00d0\u00b7\u00d0\u00b2\u00d1\u0080\u00d0\u00b0\u00d1\u0089\u00d0\u00b0\u00d0\u00b5\u00d1\u0082 \u00d1\u0081\u00d0\u00bf\u00d0\u00b8\u00d1\u0081\u00d0\u00be\u00d0\u00ba \u00d0\u00b3\u00d0\u00be\u00d1\u0080\u00d0\u00be\u00d0\u00b4\u00d0\u00be\u00d0\u00b2 \u00d0\u00b4\u00d0\u00bb\u00d1\u008f \u00d1\u0083\u00d0\u00ba\u00d0\u00b0\u00d0\u00b7\u00d0\u00b0\u00d0\u00bd\u00d0\u00bd\u00d0\u00be\u00d0\u00b9 \u00d1\u0081\u00d1\u0082\u00d1\u0080\u00d0\u00b0\u00d0\u00bd\u00d1\u008b \u00d0\u00b2 \u00d1\u0084\u00d0\u00be\u00d1\u0080\u00d0\u00bc\u00d0\u00b0\u00d1\u0082\u00d0\u00b5 JSON"}},{"line":41,"kind":12,"name":"repository"},{"line":41,"kind":12,"name":"location_repo"},{"line":44,"kind":12,"name":"decode_utf8"}],"version":5}