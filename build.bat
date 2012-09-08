REM - The script relies on having the gh-pages branch checked out next to this directory in a folder named "Cave - doc"

REM - Output to bin\Cave.swf
"\Program Files (x86)\FlashDevelop\Tools\fdbuild\fdbuild.exe" -compiler:"\Program Files (x86)\FlashDevelop\Tools\flexsdk" Cave.as3proj

REM - Copy into doc directory
copy /Y bin\Cave.swf "..\Cave - doc\bin\Cave.swf"

REM - Write cachebuster
pushd "..\Cave - doc"
cscript replace.vbs //Nologo "{cachebuster}/%random%" < gameframe-tmpl.html > gameframe.html

REM - Commit!
git commit -am "New version"
git push

popd