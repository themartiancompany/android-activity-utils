# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

SHELL = bash
_PROJECT=android-activity-utils
PREFIX ?= /usr/local
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/android-activity-utils
BIN_DIR=$(DESTDIR)$(PREFIX)/bin

DOC_FILES=$(wildcard *.rst)
SCRIPT_FILES=$(wildcard android-activity-utils/*)

all: build-man

prepare:

	git \
	  submodule \
	    update \
	    --init \
	      "man" || \
	true

build-man:

	make \
	  prepare
	mkdir \
	  -p \
	  "build/man"
	cd \
	  "man"; \
	make \
	  build-man
	cp \
	  "man/build/"* \
	  "build/man"

check: shellcheck

shellcheck:

	shellcheck \
	  -s \
	    "bash" \
	  $(SCRIPT_FILES)

install: install-scripts install-doc install-man

install-doc:

	install \
	  -vDm644 \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	make \
	  build-man
	cd \
	  "man"; \
	  make \
	    install-man

install-scripts:

	install \
	  -vDm755 \
	  "$(_PROJECT)/activities-info" \
	  "$(BIN_DIR)/activities-info"
	install \
	  -vDm755 \
	  "$(_PROJECT)/activity-launch" \
	  "$(BIN_DIR)/activity-launch"
	install \
	  -vDm755 \
	  "$(_PROJECT)/activity-focused" \
	  "$(BIN_DIR)/activity-focused"

uninstall: uninstall-scripts

uninstall-scripts:

	rm \
	  -vrf \
	  "$(BIN_DIR)/activities-info" \
	  "$(BIN_DIR)/activity-focused" \
	  "$(BIN_DIR)/activity-launch"

.PHONY: check install install-doc install-man install-scripts shellcheck uninstall uninstall-scripts
