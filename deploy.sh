# Compile
mkdir -p bin
~/Development/air3-6/bin/mxmlc -output bin/cave.swf -source-path flixel -- src/Cave.as

if [ $? -eq 0 ]
	then 

	# Copy to deploy dir
	cp -f bin/cave.swf ../cave-doc/bin/cave.swf

	pushd ../cave-doc

	# Cachebuster
	sed s/{cachebuster}/`date +%s`/ gameframe-tmpl.html > gameframe.html

	# Publish
	git commit -am "New version"
	git push

	popd
fi