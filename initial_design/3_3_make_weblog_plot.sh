#!/bin/bash
/bin/rm -f top_fragment.fasta
for x in $(/bin/ls fragments_exact_extract/fragonly_*.pdb)
do
	~/scripts/pdb2fasta.py $x >> top_fragment.fasta
done

~/bin/muscle3.8.31_i86linux64 -in top_fragment.fasta -quiet -gapopen -10000 -out top_fragment.alignment
/work/shilei/bin/weblogo/seqlogo -f top_fragment.alignment -o top_fragment_sequence -F EPS -s 1 -k 0 -x IntegrinPeptideMatch -y TopFragSequence -c -n -p -S -Y -b; ~/scripts/gnuplot/ps2png.sh top_fragment_sequence.eps
