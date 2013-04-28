#!/bin/bash
source CONFIG.sh

rm -rf $TMPFOLDER
mkdir -p $TMPFOLDER

echo "find new images..."
find final -iregex '.*\.jpg' > $TMPFOLDER/all_images.txt
find raw   -iregex '.*\.jpg' >> $TMPFOLDER/all_images.txt

echo "create folders for new images..."
touch $TMPFOLDER/new_images.txt
cat $TMPFOLDER/all_images.txt | while read line
do
  if [ ! -f "lq_$line" ]; then    
    mkdir -p "$(dirname "$(echo lq_"$line")")"
    echo $line >> $TMPFOLDER/new_images.txt
  fi
done

echo "convert new images..."
cat $TMPFOLDER/new_images.txt | parallel -j $CORES "echo {}...; convert -resize ${LQ_WIDTH}x${LQ_HEIGHT}\> -quality $LQ_QUALITY {} lq_{}"

echo "sync lq_final..." &&
rsync -arz --progress lq_final $SSH_DEST &&
echo "sync lq_raw..." &&
rsync -arz --progress lq_raw $SSH_DEST &&
echo "sync final..." &&
rsync -arz --progress final $SSH_DEST &&
echo "sync raw \(without .CR2s\)..." &&
rsync -arz --progress --exclude '*.CR2' raw $SSH_DEST &&
echo "sync raw..." &&
rsync -arz --progress raw $SSH_DEST &&
echo "sync edit..." &&
rsync -arz --progress edit $SSH_DEST &&
echo "full sync done!"