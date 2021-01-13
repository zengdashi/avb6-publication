#!/bin/bash
rm -rf fragments_extend_extract_align_to_target 3_1_remove_clashing_extend_fragments.joblist fragments_extend_extract_align_filter_no_clash
mkdir fragments_extend_extract_align_to_target fragments_extend_extract_align_filter_no_clash
 
for x in $(/bin/ls fragments_extend_extract/frag_*.pdb)
do
        name=`basename $x`
	tag=`echo $name | sed 's/frag_/fragonly_/g'`
        frag=`/bin/ls -1 fragments_exact_extract/$tag`
        /work/krypton/bin/TMalign $frag clean_chop_mutate_peptide.pdb -m matrix.txt
        cp target.pdb fragments_extend_extract_align_to_target/aligned_$name
        perl /work/krypton/scripts/rot.pl matrix.txt $x | awk '$1=="ATOM" {print substr($0,1,21)"B"substr($0,23,57)}' >> fragments_extend_extract_align_to_target/aligned_$name
        /bin/rm -f matrix.txt
	echo "/bin/rm -f fragments_extend_extract_align_to_target/aligned_$name.sc; ~/git_rosetta/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s fragments_extend_extract_align_to_target/aligned_$name -overwrite -nstruct 1 -parser:protocol toAla_ddg.xml -out:file:scorefile fragments_extend_extract_align_to_target/aligned_$name.sc -out:prefix fragments_extend_extract_align_filter_no_clash/" >> 3_1_remove_clashing_extend_fragments.joblist
done
