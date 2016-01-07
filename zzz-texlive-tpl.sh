#
#    /etc/profile.d/zzz-texlive.sh 
#

TL_DIR="/usr/local/texlive/TL_VERSION"

arch=`arch`
case $arch in
    i?86) arch=i386;;
    x86_64) arch=x86_64;;
esac
  
x="`echo $PATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
export PATH=${TL_DIR}/bin/${arch}-linux:${x}

x="`echo $MANPATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
export MANPATH=${TL_DIR}/texmf-dist/doc/man:${x}

x="`echo $INFOPATH | sed 's|[^:]*/texlive/[^:]*:||g'`"
export INFOPATH=${TL_DIR}/texmf-dist/doc/info:${x}

unset TEXINPUTS
unset TEXMFCONFIG

unset x
