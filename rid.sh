cd $PWD
for file in `ls`
do
	cat $file | sed 's//\n/g' | grep -v '^$' > $file.bak
	mv $file.bak $file
done
