#!/bin/bash
source CONFIG.sh

#make sure a lastrun file exits
if [ ! -f '.lastrun' ]; then
  touch -t 197001010000 .lastrun
fi

echo "find new images..."
find final -iregex '.*\.jpg' -newer .lastrun > $TMPFILE
find raw   -iregex '.*\.jpg' -newer .lastrun >> $TMPFILE

echo "create folders for new images..."
cat $TMPFILE | while read line
do
  mkdir -p $(dirname $(echo lq_"$line"))
done

echo "convert new images..."
cat $TMPFILE | parallel -j $CORES 'echo {}...; convert -resize ${LQ_WIDTH}x${LQ_HEIGHT}\> -quality $LQ_QUALITY {} lq_{}' && 
touch .lastrun

echo "sync lq_final..." &&
rsync -arz --progress lq_final $SSH_DEST &&
echo "sync lq_raw..." &&
rsync -arz --progress lq_raw $SSH_DEST &&
echo "sync final..." &&
rsync -arz --progress final $SSH_DEST &&
echo "sync raw (without .CR2's)..." &&
rsync -arz --progress --exclude '*.CR2' raw $SSH_DEST &&
echo "sync raw..." &&
rsync -arz --progress raw $SSH_DEST &&
echo "sync edit..." &&
rsync -arz --progress edit $SSH_DEST &&
echo "full sync done!"