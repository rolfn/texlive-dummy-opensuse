texlive-dummy-opensuse
======================

This is a "dummy-package" which achieves the dependencies of the 
openSUSE TeX Live packages without installing the real files. This 
makes it possible to install the original TeX Live distribution 
(http://www.tug.org/texlive/) without the overhead of the openSUSE 
packages. The "dummy-package" provides scripts in "/etc/profile.d/" 
for setting the correct paths of the TeX Live binaries (assuming 
the installation path "/usr/local/texlive").

Install this package with:
 
`zypper in --allow-unsigned-rpm texlive-dummy-2024.9999-1.noarch.rpm`

The GIT repository of the package is:

https://github.com/rolfn/texlive-dummy-opensuse

Permission is granted to copy, distribute and/or modify this software
under the terms of the LaTeX Project Public License (LPPL), version
1.3. The LPPL maintenance status of this software is "maintained".

