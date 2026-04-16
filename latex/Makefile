.PHONY: all
.DEFAULT_GOAL := all

all:
	@if [ ! -d .git ]; then \
		git init; \
		git branch -M main; \
		git add .; \
		direnv allow; \
		echo "Setup completed successfully. Removing Makefile..."; \
		rm Makefile; \
		git add .; \
		git commit -m "Initial commit"; \
	else \
		echo "Aborted: .git directory already exists."; \
	fi
