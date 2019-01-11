cd ~/src/openstreetmap-carto
WORKOSM_DIR=/home/renderer/osmosis_workdir

if [ ! -f  $WORKOSM_DIR/state.txt ]; then
        wget "https://replicate-sequences.osm.mazdermind.de/?"`date -u +"%Y-%m-%d"`"T00:00:00Z" -O $WORKOSM_DIR/state.txt
        osmosis --read-replication-interval-init workingDirectory=$WORKOSM_DIR
fi

if [ ! -f  $WORKOSM_DIR/configuration.txt ]; then
        osmosis --read-replication-interval-init workingDirectory=$WORKOSM_DIR
fi


if [ ! -f  $WORKOSM_DIR/shape.poly ]; then
        wget https://download.geofabrik.de/europe/germany/niedersachsen.poly -O $WORKOSM_DIR/shape.poly
fi



WORKOSM_DIR=/home/renderer/osmosis_workdir
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

osmosis -v --read-replication-interval workingDirectory="${WORKOSM_DIR}" --simplify-change --write-xml-change $WORKOSM_DIR/pipline.osc 
/home/renderer/src/regional/trim_osc.py -d gis -p "${WORKOSM_DIR}/shape.poly" $WORKOSM_DIR/pipline.osc $WORKOSM_DIR/pipline.nds.osc
osm2pgsql -v --append -s -C 300 -G --hstore --style /home/renderer/src/openstreetmap-carto/openstreetmap-carto.style --tag-transform-script /home/renderer/src/openstreetmap-carto/openstreetmap-carto.lua -d gis $WORKOSM_DIR/pipline.nds.osc

rm $WORKOSM_DIR/pipline.osc
rm $WORKOSM_DIR/pipline.nds.osc
