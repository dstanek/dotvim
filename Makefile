DOTVIM_INSTALL_DIR = ~/.vim
PYENV_INSTALL_DIR = $(DOTVIM_INSTALL_DIR)/pyenv
PYLIBS = $(DOTVIM_INSTALL_DIR)/pylibs
VIRTUALENV = $(PYLIBS)/virtualenv.py

PYTHON = python
LINK = ln

# generic target to create any necessary dotfiles
$(HOME)/.%:
	$(LINK) -s $(CURDIR)/$(subst .,,$(suffix $@)) $@

$(HOME)/.vim:
	$(LINK) -s $(CURDIR) $@

# create an virtualenv environ to install the libraries required for
# editing Python code
pyenv:
	$(PYTHON) $(VIRTUALENV) $(PYENV_INSTALL_DIR)
	$(PYENV_INSTALL_DIR)/bin/pip install -r $(PYLIBS)/requirements.txt > /dev/null

.PHONY: install
install: $(HOME)/.vimrc $(HOME)/.gvimrc $(HOME)/.vim pyenv
