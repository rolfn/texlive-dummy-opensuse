
# Rolf Niepraschk, Rolf.Niepraschk@gmx.de

NAME = texlive-dummy
YEAR = 2014
VERSION = $(YEAR).9999
RELEASE = 3
DATE = "2014/08/15"

DESCRIPTION = \
'This is a "dummy-package" which achieves the dependencies of the \
openSUSE TeX Live packages without installing the real files. This \
makes it possible to install the original TeX Live distribution \
(http://www.tug.org/texlive/) without the overhead of the openSUSE \
packages. The "dummy-package" provides scripts in "/etc/profile.d/" \
for setting the correct pathes of the TeX Live binaries (you should \
use the default installation path "/usr/local/texlive/"). After \
installing a new-year "dummy-package" uninstall the previous one.'

BUILD_ROOT = $(PWD)/rpmbuild

rpm : clean init $(NAME).spec README zzz-texlive.sh zzz-texlive.csh
	rpmbuild --define "_topdir $(BUILD_ROOT)" -bb $(NAME).spec
	mv $(BUILD_ROOT)/RPMS/noarch/$(NAME)-$(VERSION)-$(RELEASE).noarch.rpm .

srpm : clean init $(NAME).spec README zzz-texlive.sh zzz-texlive.csh
	rpmbuild --define "_topdir $(BUILD_ROOT)" -bs $(NAME).spec
	mv $(BUILD_ROOT)/SRPMS/$(NAME)-$(VERSION)-$(RELEASE).src.rpm .

all : rpm srpm

README.md :
	@echo "texlive-dummy-opensuse" > $@
	@echo "======================" >> $@
	@echo "" >> $@
	@echo $(DESCRIPTION) >> $@
	@echo "" >> $@
	@cat LICENSE >> $@
	@echo "" >> $@
	@echo "Rolf Niepraschk, Rolf.Niepraschk@gmx.de, $(DATE)" >> $@

README :
	@echo "texlive-dummy-opensuse" > $@
	@echo "======================" >> $@
	@echo "" >> $@
	@echo $(DESCRIPTION)\
    "See also: https://github.com/rolfn/texlive-dummy-opensuse" >> $@
	@echo "" >> $@
	@cat LICENSE >> $@
	@echo "" >> $@
	@echo "Rolf Niepraschk, Rolf.Niepraschk@gmx.de, $(DATE)" >> $@

zzz-texlive.sh : zzz-texlive-tpl.sh
	@cat $< | sed 's/TL_VERSION/$(YEAR)/g' > $@

zzz-texlive.csh : zzz-texlive-tpl.csh
	@cat $< | sed 's/TL_VERSION/$(YEAR)/g' > $@

init : $(NAME).spec README zzz-texlive.sh zzz-texlive.csh
	@mkdir -p $(BUILD_ROOT)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
	@cp $+ $(BUILD_ROOT)/SOURCES

clean :
	@rm -rf $(BUILD_ROOT) zzz-texlive.sh zzz-texlive.csh TL_PACKAGES.lst

TL_PACKAGES.lst :
	@zypper se  texlive | \
    awk -F '|' '/texlive/ && !/texlive-dummy/ && !/texlive-config/ && $$2 !~ /debug/ \
    {print $$2}' | uniq > $@

$(NAME).spec : TL_PACKAGES.lst
	@echo "#" > $@
	@echo "# spec file for package $(NAME)" >> $@
	@echo "#" >> $@
	@echo "Name: $(NAME)" >> $@
	@echo "Summary: A "dummy-package" for TeX Live" >> $@
	@echo "License: LPPL" >> $@
	@echo "Group: Metapackages" >> $@
	@echo "" >> $@
	@echo "Version: $(VERSION)" >> $@
	@echo "Release: $(RELEASE)" >> $@
	@echo "Source0: README" >> $@
	@echo "Source1: zzz-texlive.sh" >> $@
	@echo "Source2: zzz-texlive.csh" >> $@
	@echo "" >> $@
	@echo "Provides: %{name} texlive psutils xindy xindy-doc xindy-rules" >> $@
	@cat TL_PACKAGES.lst | sed 's/^\(.*\)/Provides: \1/' >> $@
	@echo "Obsoletes: texlive < %{version}" >> $@
	@cat TL_PACKAGES.lst | sed 's/^\(.*\)/Obsoletes: \1/' >> $@
	@echo "BuildRoot: %{_tmppath}/%{name}-%{version}-build" >> $@
	@echo "BuildArch: noarch" >> $@
	@echo "Recommends: perl-Tk" >> $@
	@echo "" >> $@
	@echo "%description" >> $@
	@echo $(DESCRIPTION) >> $@
	@echo "" >> $@
	@echo "%prep" >> $@
	@echo "%setup -c -T" >> $@
	@echo "cp %{SOURCE0} ." >> $@
	@echo "" >> $@
	@echo "%build" >> $@
	@echo "#nothing to do" >> $@
	@echo "" >> $@
	@echo "%install" >> $@
	@echo "mkdir -p %{buildroot}%{_sysconfdir}/profile.d" >> $@
	@echo "install -m 644 %{SOURCE1} %{buildroot}%{_sysconfdir}/profile.d/" >> $@
	@echo "install -m 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/profile.d/" >> $@
	@echo "" >> $@
	@echo "%clean" >> $@
	@echo "rm -rf %{buildroot}" >> $@
	@echo "" >> $@
	@echo "%files" >> $@
	@echo "%defattr(-, root, root)" >> $@
	@echo "%doc README" >> $@
	@echo "%config %{_sysconfdir}/profile.d/zzz-texlive.sh" >> $@
	@echo "%config %{_sysconfdir}/profile.d/zzz-texlive.csh" >> $@
	@echo "" >> $@
	@echo "%changelog" >> $@
	@cat CHANGES >> $@
	@echo "" >> $@

dist : all
	@rm -rf openSUSE
	@mkdir openSUSE
	@cp -p README $(NAME)-$(VERSION)-$(RELEASE).noarch.rpm \
    $(NAME)-$(VERSION)-$(RELEASE).src.rpm openSUSE/
	@zip $(NAME)-$(YEAR)-$(RELEASE).zip -r openSUSE

