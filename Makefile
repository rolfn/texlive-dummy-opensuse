
# Rolf Niepraschk, 2014/08/13, Rolf.Niepraschk@gmx.de

DESCRIPTION = \
'This is a "dummy-package" which achieves the dependencies of the \
openSUSE TeX Live packages without installing the real files. This \
makes it possible to install the original TeX Live distribution \
(http://www.tug.org/texlive/) without the overhead of the openSUSE \
packages. The "dummy-package" provides scripts in "/etc/profile.d/" \
for setting the correct pathes of the TeX Live binaries (you should \
use the default installation path "/usr/local/texlive/"). After \
installing a new-year "dummy-package" uninstall the previous one.'

LICENSE = \
'Permission is granted to copy, distribute and/or modify this \
software under the terms of the LaTeX Project Public License \
(LPPL), version 1.3. \
\
The LPPL maintenance status of this software is "maintained".'

README.md :
	echo -e 'texlive-dummy-opensuse' > $@
	echo -e '======================'\\n >> $@
	echo -e $(DESCRIPTION)\\n >> $@
	echo -e $(LICENSE)\\n >> $@
	echo -e 'Rolf Niepraschk, Rolf.Niepraschk@gmx.de' >> $@