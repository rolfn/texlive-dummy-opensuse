#
#    /etc/profile.d/zzz-texlive.csh 
#

set TL_DIR="TL_PATH/TL_VERSION"

set arch=`arch`
switch ( $arch )
  case i?86: 
    set arch=i386
endsw

set x="`echo $PATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
setenv PATH ${TL_DIR}/bin/${arch}-linux:${x}

set x="`echo $MANPATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
setenv MANPATH ${TL_DIR}/texmf-dist/doc/man:${x}

set x="`echo $INFOPATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
setenv INFOPATH ${TL_DIR}/texmf-dist/doc/info:${x}

unset TEXINPUTS
unset TEXMFCONFIG


