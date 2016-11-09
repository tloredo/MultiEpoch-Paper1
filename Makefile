# latexmk parts adapted from:
# http://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project

# pdflatex versions:
base=ms


# Include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: MyDoc.pdf all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: slides

# CUSTOM BUILD RULES

# Recall:  '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

#%.tex: %.raw
#	./raw2tex $< > $@

#%.tex: %.dat
#	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

paper: $(base).tex
	latexmk -bibtex-cond -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make $(base).tex

clean:
	latexmk -c

clobber:
	latexmk -C


# View PDF in a platform-specific viewer:

UNAME := $(shell uname)
view:  $(base).pdf
ifeq ($(UNAME),Darwin)
	open -a Skim $(base).pdf
else
	acroread -openInNewWindow -geometry 800x825 $(base).pdf &
endif


# Bundling targets:
#
# Include $(base).bbl on the 1st 'tar' line if needed.
# The file lists are partly found using tex_file_list.py.

ARXIV_FIGS = fig/f1.png fig/f2.png fig/f3.png fig/f4.png fig/f5.png fig/f6.png fig/f7.png fig/f8.png fig/app-fig-a3 fig/app-fig-a4
# Include class and bib style files here if needed:
ARXIV_INPUTS =

arxiv:
	tar czf arxiv.tgz $(base).tex  \
	$(ARXIV_INPUTS) $(ARXIV_FIGS)
	mkdir test
	tar -C test -xf arxiv.tgz
	echo 'arxiv.tgz created and upacked into "test" folder; test and delete...'
