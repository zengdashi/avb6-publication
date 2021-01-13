#!/bin/bash
/bin/rm -f 4_extract_subpdb_from_nonclashing_scaffold.joblist

for k in $(/bin/ls fragments_extend_extract_align_filter_no_clash/*_0001.pdb)
do
	name=`basename $k | sed -e 's/_0001//g' -e 's/aligned_//g'`
	pdb=`/bin/ls -1 fragments_extend_extract/$name`
	x=`basename $pdb`
 	echo $x

 	name1=`echo $x | awk -F"_" '{print substr($3,2,2)}'`
 	name2=`echo $x | awk -F"_" '{print $3}'`
 	start=`echo $x | awk -F"_" '{print $4}'`
 	end=`echo $x | awk -F"_" '{print $5}'`
 	frag=`echo $x `
 	echo "/work/robetta/src/rosetta/fragment_tools/pdb2vall/structure_profile_scripts/dssp2threestateSS.pl shift_pdb/${name2}_shift.pdb | awk 'NR>1' | tr '\n' ' ' | sed  's/ //g' | awk 'NR>0' > shift_pdb/${name2}_shift.dssp  && ~/scripts/keep_partpdb_contacting_start_end_dssp_continue.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_continue_"$name2"_"$start"_"$end".pdb ; ~/scripts/keep_partpdb_contacting_start_end_dssp_distant.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_distant_"$name2"_"$start"_"$end".pdb; cp fragments_extend_extract/"$frag" . ; cp shift_pdb/"$name2"_shift.pdb ." >> 4_extract_subpdb_from_nonclashing_scaffold.joblist
done
cat 4_extract_subpdb_from_nonclashing_scaffold.joblist | parallel -j20
/bin/rm -rf fragments_extend_nonclashing
mkdir fragments_extend_nonclashing
for x in $(/bin/ls part_continue*.pdb); do nx=`wc -l $x | awk '{print $1}'`; if [ $nx -lt 10  ]; then /bin/rm -f $x; fi done
/work/shilei/git_rosetta/Rosetta/main/source/bin/tmalign_cluster.default.linuxgccrelease -database /work/shilei/git_rosetta/Rosetta/main/database/ -s part_continue_*.pdb -tmalign_cluster::cluster_radius 0.8
mv frag_*.pdb *_shift.pdb part_*.pdb c_*.pdb fragments_extend_nonclashing
scp -r fragments_extend_nonclashing shilei@arlo:/Users/shilei/Documents/Research/Projects/InterfaceDesign/Integrin/Designs/Fragment_match_look_for_motif
