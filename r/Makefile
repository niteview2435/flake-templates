.PHONY: all
.DEFAULT_GOAL := all

all:
	@if [ ! -d .git ]; then \
		git init; \
		git branch -M main; \
		git add .; \
		git commit -m "Initial commit"; \
		direnv allow; \
		echo "Setup completed successfully. Removing Makefile..."; \
		rm Makefile; \
	else \
		echo "Aborted: .git directory already exists."; \
	fi
