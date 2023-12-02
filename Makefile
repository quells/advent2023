.PHONY: test
test:
	testament pattern "tests/*.nim"

.PHONY: clean
clean:
	-rm -r nimcache testresults
	-git ls-files -o | xargs rm
