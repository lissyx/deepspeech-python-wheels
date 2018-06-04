#!/bin/bash

baseFinalUrl=https://lissyx.github.io/deepspeech-python-wheels

for whl in $@;
do
  fname="$(basename ${whl})"
  dname="$(echo $fname | cut -d '-' -f 1)"
  mkdir -p ${dname}
  cp ${whl} ${dname}/${fname}
  git add ${dname}/${fname}
done;

links=""
allpy=$(find . -mindepth 1 -maxdepth 1 -type d | grep -v '\.git')
for onepy in ${allpy};
do
  dname=$(basename "$onepy" )
  link="<a href=\"${baseFinalUrl}/${dname}/\">${dname}</a>"
  links="${links}
  ${link}"
done;

cat <<EOF > index.html
<!DOCTYPE html>
<html>
  <head>
    <title>Simple index</title>
  </head>
  <body>
${links}
  </body>
</html>
EOF
git add index.html

for pkg in ${allpy};
do
  dname=$(basename "${pkg}" )

  links_pkg=""
  for _fname in ${dname}/*.whl;
  do
    fname=$(basename "${_fname}")
    fsha="$(sha256sum ${dname}/${fname} | awk '{ print $1 }')"
    link="<a href=\"${baseFinalUrl}/${dname}/${fname}#sha256=${fsha}\">${fname}</a><br/>"
    links_pkg="${links_pkg}
  ${link}"
  done;

  cat <<EOF > ${pkg}/index.html
<!DOCTYPE html>
<html>
  <head>
    <title>Links for ${dname}</title>
  </head>
  <body>
  <h1>Links for ${dname}</h1>
${links_pkg}
  </body>
</html>
EOF
  git add ${pkg}/index.html
done;
