mkdir -p bin

~/Development/air3-6/bin/mxmlc -output bin/cave.swf -source-path flixel -- src/Cave.as

if [ $? -eq 0 ]
	then 
	~/Development/air3-6/bin/fdb bin/cave.swf
fi
