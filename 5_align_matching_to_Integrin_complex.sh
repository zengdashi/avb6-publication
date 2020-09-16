#!/bin/bash
for k in $(/bin/ls -d fragments_extend_bestrms fragments_extend_cluster*)
do
	for x in $(/bin/ls $k/c_*.pdb)
	do
		name=`basename $x`	
		tag=`echo $name | awk -F"_" '{print $7"_"$8"_"$9}' | sed 's/.pdb//g'`
		frag=`/bin/ls -1 fragments_exact_extract/fragonly_*_${tag}_*.pdb | head -1`
		/work/krypton/bin/TMalign $frag clean_chop_mutate_peptide.pdb -m matrix.txt
		cp target.pdb ${k}/aligned_$name
		perl /work/krypton/scripts/rot.pl matrix.txt $k/part_*$tag*.pdb | awk '$1=="ATOM" {print substr($0,1,21)"B"substr($0,23,57)}' >> ${k}/aligned_$name
		/bin/rm -f matrix.txt
	done
done

scp -r fragments_extend_cluster* fragments_extend_bestrms shilei@arlo:/Users/shilei/Documents/Research/Projects/InterfaceDesign/Integrin/Designs/Fragment_match_look_for_motif
