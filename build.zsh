#!/bin/zsh

for dir in part-*
do
  echo "" > $dir/README.md  # flush readme
  for file in $dir/*.md(n)
  do
    if [[ $file == $dir/"README.md" ]]; then
      continue
    fi
    cat $file >> $dir/README.md
    echo "\n\n---\n" >> $dir/README.md
  done
done