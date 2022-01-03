EMACS = emacs
ABS_EMACS := $(shell which $(EMACS))
EMACSARGS = -Q -nw --batch --eval '(setq load-prefer-newer t)'

MAIN_EL = cfg.el
MAIN_ELC = $(MAIN_EL:.el=.elc)

SUB_EL = $(wildcard sub/*.el)
SUB_ELC = $(SUB_EL:.el=.elc)

$(MAIN_ELC): $(MAIN_EL) $(ABS_EMACS) $(SUB_ELC)
	$(EMACS) $(EMACSARGS) -L . --batch -f batch-byte-compile $<

$(SUB_ELC): %.elc: %.el $(ABS_EMACS)
	$(EMACS) $(EMACSARGS) -L sub --batch -f batch-byte-compile $<
