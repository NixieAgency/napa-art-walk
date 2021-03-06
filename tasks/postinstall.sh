#!/usr/bin/env bash
d=`date +%s`
cssbundle="bundle"$d".min.css"
jsbundle="bundle"$d".min.js"

echo "running postinstall tasks..."

#bower build
bower cache clean
(cd client; bower install)

#build css
rm client/app/bundle*.min.css
#(cd client/arts/css; cat bootstrap-overrides.css theme.css > $cssbundle )
#pending: compressed css was breaking footer styling
(cd client/app;
cat \
bootstrap-3.3.4-dist/css/bootstrap.css \
app.css \
| cleancss -o $cssbundle )

#build js
rm client/app/bundle*min.js
(cd client/app;
uglifyjs \
app.js \
components/googleSheetsHelper/googleSheetsHelper.js \
components/copycat/copycat.js \
views/landing/landing.js \
views/about/about.js \
views/archive/archive.js \
views/gallery/gallery.js \
views/press/press.js \
views/news/news.js \
views/sponsors/sponsors.js \
views/map/map.js \
views/art/art.js \
-o $jsbundle -mc )

echo { \"css\": \"$cssbundle\", \"js\": \"$jsbundle\"  } > config/assetbuilds.json
