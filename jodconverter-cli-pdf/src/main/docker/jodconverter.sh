#!/usr/bin/env bash
TEMPDIR=$(mktemp -d)

trap "exit 1"         HUP INT PIPE QUIT TERM
trap "rm -rf $TEMPDIR" EXIT

# see https://github.com/faas-and-furious/faas-contributor-stamp/blob/master/function/entry.sh
export FILE=file.bin
if [ ! -z "${Http_X_File}" ] ;
then
        FILE="${Http_X_File}"
fi

cat - > "${TEMPDIR}/${FILE}" # stdin to FILE

jodconverter-cli/bin/jodconverter-cli -sFDSelectPdfVersion=1 "${TEMPDIR}/${FILE}" ${TEMPDIR}/file.pdf > /dev/null
cat ${TEMPDIR}/file.pdf

