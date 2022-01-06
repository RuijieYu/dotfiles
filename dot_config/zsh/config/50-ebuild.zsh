# convenient function for ebuild
ebuild-all() {
    find "$@" \
	 -name "*.ebuild" \
	 -exec \
	 ebuild {} \
	 manifest \;
}

# define completion where ebuild-all takes directories
