#!/bin/bash
cutoff=0.5
/bin/rm -f 4_extract_subpdb_from_best_scaffold.joblist
pdblist=`awk -v x=$cutoff '$6<=x' frags.fsc.score.2000.8mers  | awk '{print "ClusterFragmentExtend/*"$3$4"_"$2"*_"$6".pdb"}' | tr '\n' ' '`
for x in $pdblist
do
	if [ -f $x ]
	then
	echo $x

	cluster=`echo $x | awk -F"_" '{print $2}'`
	name1=`echo $x | awk -F"_" '{print substr($6,2,2)}'`
	name2=`echo $x | awk -F"_" '{print $6}'`
	start=`echo $x | awk -F"_" '{print $7}'`
	end=`echo $x | awk -F"_" '{print $8}'`
	frag=`echo $x | awk -F"_" '{print $4"_"$5"_"$6"_"$7"_"$8"_"$9}'`
	echo "/work/robetta/src/rosetta_server/external/Rosetta/tools/fragment_tools/pdb2vall/structure_profile_scripts/dssp2threestateSS.pl shift_pdb/${name2}_shift.pdb | awk 'NR>1' | tr '\n' ' ' | sed  's/ //g' | awk 'NR>0' > shift_pdb/${name2}_shift.dssp  && ~/scripts/keep_partpdb_contacting_start_end_dssp_continue.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_continue_${cluster}_"$name2"_"$start"_"$end".pdb ; ~/scripts/keep_partpdb_contacting_start_end_dssp_distant.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_distant_${cluster}_"$name2"_"$start"_"$end".pdb; cp fragments_extend_extract/"$frag" . ; cp shift_pdb/"$name2"_shift.pdb ." >> 4_extract_subpdb_from_best_scaffold.joblist
	#echo "/work/robetta/src/rosetta/fragment_tools/pdb2vall/structure_profile_scripts/dssp2threestateSS.pl shift_pdb/${name2}_shift.pdb | awk 'NR>1' | tr '\n' ' ' | sed  's/ //g' | awk 'NR>0' > shift_pdb/${name2}_shift.dssp  && ~/scripts/keep_partpdb_contacting_start_end_dssp_continue.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_continue_${cluster}_"$name2"_"$start"_"$end".pdb ; ~/scripts/keep_partpdb_contacting_start_end_dssp_distant.py shift_pdb/"$name2"_shift.pdb "$start" "$end" shift_pdb/"${name2}"_shift.dssp  > part_distant_${cluster}_"$name2"_"$start"_"$end".pdb; cp fragments_extend_extract/"$frag" . ; cp shift_pdb/"$name2"_shift.pdb ." >> 4_extract_subpdb_from_best_scaffold.joblist
	fi
done
cat 4_extract_subpdb_from_best_scaffold.joblist | parallel -j20
/bin/rm -rf fragments_extend_bestrms
mkdir fragments_extend_bestrms
for x in $(/bin/ls part*.pdb); do nx=`wc -l $x | awk '{print $1}'`; if [ $nx -lt 10  ]; then /bin/rm -f $x; fi done
/work/shilei/git_rosetta/Rosetta/main/source/bin/tmalign_cluster.boost_thread.linuxgccrelease -database /work/shilei/git_rosetta/Rosetta/main/database/ -s part_continue_*.pdb -tmalign_cluster::cluster_radius 0.8 -j 20
clusterexist=`find ./ -name "c_*.pdb" 2>/dev/null`
if [ -z "$clusterexist" ]; then /work/shilei/git_rosetta/Rosetta/main/source/bin/tmalign_cluster.default.linuxgccrelease -database /work/shilei/git_rosetta/Rosetta/main/database/ -s part_continue_*.pdb -tmalign_cluster::cluster_radius 0.8; fi
mv frag_*.pdb *_shift.pdb part_*.pdb c_*.pdb fragments_extend_bestrms
scp -r fragments_extend_bestrms shilei@arlo:/Users/shilei/Documents/Research/Projects/InterfaceDesign/Integrin/Designs/Fragment_match_look_for_motif
