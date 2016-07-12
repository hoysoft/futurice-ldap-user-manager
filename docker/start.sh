#!/bin/bash

./manage.py build_solr_schema > schema.xml
cp schema.xml apache-solr-3.6.2/example/solr/conf/
cp apache-solr-3.6.2/example/solr/conf/stopwords.txt apache-solr-3.6.2/example/solr/conf/stopwords_en.txt
export PATH=$PATH:/apache-solr-3.6.2/example/solr/conf/

/etc/init.d/postgresql start &&\
	./manage.py migrate --noinput &&\
	./manage.py datamigrate &&\
	./manage.py collectstatic --noinput
/etc/init.d/postgresql stop

assetgen --profile dev assetgen.yaml

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf