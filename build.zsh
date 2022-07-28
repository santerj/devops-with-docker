#!/bin/zsh
echo "" > README.md  # flush readme

for dir in part-*
do
  for file in $dir/*.md(n)
  do
    if [[ $file == $dir/"README.md" ]]; then
      continue
    fi
    cat $file >> $dir/README.md
    echo "\n" >> $dir/README.md
  done
done