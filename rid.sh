cd $PWD
for file in `ls`
do
	cat $file | sed 's/
	mv $file.bak $file
done