dummy:
	cat Makefile | grep -e '.*:$$'

master:
	pushd script/; perl xls2json.pl master/block_master.xls > ../Dri/Resources/master/block_master.json
	pushd script/; perl xls2json.pl master/item_master.xls > ../Dri/Resources/master/item_master.json

stat:
	find Dri/src -name "*.m" -exec wc -l {} \; | sort -n -r | head

gen-behav:
	ruby script/gen_behaiv.rb $(NAME)

gen-presen:
	ruby script/gen_presen.rb $(NAME)

