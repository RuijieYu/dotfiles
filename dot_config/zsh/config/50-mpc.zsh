# this is a workaround for an issue with mpc completer (shipped by
# zsh), which tries to add formatted strings as if they were file
# names. Until I find another solution, I will disable the formatting.
_MPC_FORMAT='[[[%artist%|(P)%performer|(C)%composer%%]#|%title%]]|[%file%]'
