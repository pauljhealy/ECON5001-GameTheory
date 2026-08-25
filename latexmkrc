# latexmk configuration, read automatically from the project root.
#
# Overleaf's build servers run in UTC, so \today and \DTMcurrenttime on the
# title slides came out four or five hours ahead of Columbus. Setting TZ here
# fixes both, because latexmk passes this environment on to pdflatex.
#
# This file is Perl. Keep the trailing semicolons.

$ENV{'TZ'} = 'America/New_York';
