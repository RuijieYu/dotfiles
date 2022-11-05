# TODO: how to find historic "ls"? or does this matter in my
# setup?

# colorized ls for each variant (gls from homebrew)
for ls in ls gls; do
    found "$ls" && alias "$ls=$ls --color=auto"
done
