PACKAGE = som-it
VERSION = 1.0.1
CC      = /usr/bin/g++
ARCHIVE = $(PACKAGE)-$(VERSION)

all: som-it

som-it: som-it.o
	$(CC) som-it.o -o som-it

som-it.o: som-it.cpp
	$(CC) -c som-it.cpp

clean:
	rm -rf *o som-it

install: som-it
	cp -f som-it.R ${R_LIBS}
	cp -f som-it /usr/local/bin

uninstall:
	rm /usr/local/bin/som-it
	rm ${R_LIBS}/som-it.R

package_source:
	mkdir $(ARCHIVE)
	rm -f $(ARCHIVE).tar.gz
	cp som-it.cpp $(ARCHIVE)
	cp som-it.R $(ARCHIVE)
	cp COPYING.LESSER $(ARCHIVE)
	cp README $(ARCHIVE)
	cp INSTALL $(ARCHIVE)
	cp tutorial-data.txt $(ARCHIVE)
	cp Makefile $(ARCHIVE)
	tar -cvzf $(ARCHIVE).tar.gz $(ARCHIVE)/
	rm -rf $(ARCHIVE)

