#!/bin/bash
if test ! -z "${BASH_SOURCE[0]}"
then
    file="${BASH_SOURCE[0]}"
else
    file="${0}"
fi
dir="$( dirname "${file}" )"
dir="$( cd "${dir}" && pwd )"
pushd "${dir}" >/dev/null
bash "${dir}/../bin/archer" help
bash "${dir}/../bin/archer" force-install app/spacemacs /app///emacs
result=$?
popd >/dev/null
exit $result

