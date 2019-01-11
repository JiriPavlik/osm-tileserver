cd ~/src/openstreetmap-carto

WORKOSM_DIR=/home/renderer/osmosis_workdir
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

osmosis -v --read-replication-interval workingDirectory="${WORKOSM_DIR}" --simplify-change --write-xml-change $WORKOSM_DIR/pipline.osc ~/src/regional/trim_osc.py -d gis -p "${WORKOSM_DIR}/niedersachsen.poly" $WORKOSM_DIR/pipline.osc $WORKOSM_DIR/pipline.nds.osc
osm2pgsql -v --append -s -C 300 -G --hstore --style /home/renderer/src/openstreetmap-carto/openstreetmap-carto.style --tag-transform-script /home/renderer/src/openstreetmap-carto/openstreetmap-carto.lua -d gis $WORKOSM_DIR/pipline.nds.osc

rm $WORKOSM_DIR/pipline.osc
rm $WORKOSM_DIR/pipline.nds.osc
