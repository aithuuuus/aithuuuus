DOCS=index cheatsheet contact download revision using menu stuff extra example modelines htmlchanges latex tables

HDOCS=$(addsuffix .html, $(DOCS))

.PHONY : update
update : $(HDOCS)
	@echo 'Site generated!!!'

.PHONY : extra
extra :
	cp ~/.vim/syntax/jemdoc.vim dist/

.PHONY : docs
docs : $(HDOCS)

%.html : %.jemdoc MENU jemdoc.conf
	../jemdoc -o ../html/$@ -c jemdoc.conf $< 

example.jemdoc : exampleIN.jemdoc procexample.py
	@echo 'making exampleIN'
	@./procexample.py

.PHONY : realupdate
realupdate : $(HDOCS)
	@echo -n 'Copying to (hidden) server...'
	@rsync -a --delete --copy-unsafe-links *.jemdoc html/* dist ~/jemdoc/stage/
	@echo ' done.'
	@echo 'Copying to moa...'
	rsync -a --delete --copy-unsafe-links *.jemdoc ~/jemdoc/stage/ moa:/var/www/jemdoc/
	@echo ' done.'

.PHONY : clean
clean :
	-rm -f html/*.html
