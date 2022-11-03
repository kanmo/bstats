.PHONY: clean
clean:
	rm -f ./players/*.html


.PHONY: stats
stats:
	./stats.sh
