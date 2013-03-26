```
bundle
```

In one terminal start elasticsearch:
```
$ springboard -c config -f
```

In another terminal window run:
```
$ ruby extract.rb http://d.lib.ncsu.edu/collections/sal-sitemap.xml
```

Run elasticsearch-head standalone to start querying the data: <https://github.com/mobz/elasticsearch-head>

Note: ElasticSearch config really isn't set up correctly right now and the data is actually being saved in the same place as the bundle rubberband gem.
