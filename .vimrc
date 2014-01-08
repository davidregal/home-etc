" Syntax highlighting
syntax on
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
