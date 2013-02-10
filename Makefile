dummy:

master:
	pushd script/; perl xls2json.pl master/block_master.xls > ../Dri/Resources/master/block_master.json

stat:
	find Dri/src -name "*.m" -exec wc -l {} \; | sort -n -r | head
