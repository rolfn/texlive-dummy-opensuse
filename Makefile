
# Rolf Niepraschk, Rolf.Niepraschk@gmx.de

# If you have TeX Live installed somewhere other than the default
# location, change this variable accordingly
TL_PATH = /usr/local/texlive

NAME = texlive-dummy
YEAR = 2023
VERSION = $(YEAR).9999
RELEASE = 1
DATE = "2023/03/17"

# TODO: Problem "Package header is not signed!" (createrepo?)

DESCRIPTION = \
'This is a "dummy-package" which achieves the dependencies of the\
\nopenSUSE TeX Live packages without installing the real files. This\
\nmakes it possible to install the original TeX Live distribution\
\n(http://www.tug.org/texlive/) without the overhead of the openSUSE\
\npackages. The "dummy-package" provides scripts in "/etc/profile.d/"\
\nfor setting the correct paths of the TeX Live binaries (assuming\
\nthe installation path "'$(TL_PATH)'").'

BUILD_ROOT = $(PWD)/rpmbuild/### 

all : rpm srpm

rpm : clean init $(NAME).spec README.md zzz-texlive.sh zzz-texlive.csh
	rpmbuild --define "_topdir $(BUILD_ROOT)" -bb $(NAME).spec
	mv $(BUILD_ROOT)/RPMS/noarch/$(NAME)-$(VERSION)-$(RELEASE).noarch.rpm .

srpm : clean init $(NAME).spec README.md zzz-texlive.sh zzz-texlive.csh
	rpmbuild --define "_topdir $(BUILD_ROOT)" -bs $(NAME).spec
	mv $(BUILD_ROOT)/SRPMS/$(NAME)-$(VERSION)-$(RELEASE).src.rpm .

README.md :
	@echo "texlive-dummy-opensuse" > $@
	@echo "======================" >> $@
	@echo "" >> $@
	@echo -e $(DESCRIPTION) >> $@
	@echo "" >> $@
	@cat LICENSE >> $@
	@echo "" >> $@
	@echo "The GIT repository of the package is:" >> $@
	@echo "https://github.com/rolfn/texlive-dummy-opensuse" >> $@
	@echo "" >> $@
	@echo "Rolf Niepraschk, $(DATE)" >> $@

zzz-texlive.sh : zzz-texlive-tpl.sh
	@cat $< | sed 's/TL_VERSION/$(YEAR)/g;s/TL_PATH/$(subst /,\/,$(TL_PATH))/g;' > $@

zzz-texlive.csh : zzz-texlive-tpl.csh
	@cat $< | sed 's/TL_VERSION/$(YEAR)/g;s/TL_PATH/$(subst /,\/,$(TL_PATH))/g;' > $@

init : $(NAME).spec README.md zzz-texlive.sh zzz-texlive.csh
	@mkdir -p $(addprefix $(BUILD_ROOT),BUILD BUILDROOT RPMS SOURCES SPECS SRPMS)
	@cp $+ $(BUILD_ROOT)/SOURCES

clean :
	@rm -rf $(BUILD_ROOT) zzz-texlive.sh zzz-texlive.csh TL_PACKAGES.lst \
    README.md $(NAME).spec $(NAME)-$(VERSION)-$(RELEASE).noarch.rpm

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
	@echo "Source0: README.md" >> $@
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
	@echo "%doc README.md" >> $@
	@echo "%config %{_sysconfdir}/profile.d/zzz-texlive.sh" >> $@
	@echo "%config %{_sysconfdir}/profile.d/zzz-texlive.csh" >> $@
	@echo "" >> $@
	@echo "%changelog" >> $@
	@cat CHANGES >> $@
	@echo "" >> $@

dist : all
	@rm -rf openSUSE
	@mkdir openSUSE
	@cp -p README.md $(NAME)-$(VERSION)-$(RELEASE).noarch.rpm \
    $(NAME)-$(VERSION)-$(RELEASE).src.rpm openSUSE/
	zip $(NAME)-$(YEAR)-$(RELEASE).zip -r openSUSE

