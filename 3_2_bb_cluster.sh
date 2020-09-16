for x in frag_*.pdb; do n=`grep CA $x | wc -l`; rms=` echo $x | awk -F"_" '{print $NF}' | sed 's/.pdb//g'`; echo $x $rms $n ; done | sort -k 2,2n > pdb_size.output
/bin/rm -f pdb_has_wrong_numbering_from_vall/*.pdb
awk '$NF!=20 {print "mv "$1,"pdb_has_wrong_numbering_from_vall"}' pdb_size.output  | bash
#awk '$NF!=20 || $2>0.8 {print "mv "$1,"pdb_has_wrong_numbering_from_vall"}' pdb_size.output  | bash


~/git_rosetta/Rosetta/main/source/bin/bb_cluster.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s frag_*.pdb -bb_cluster::cluster_radius 1.5
#~/git_rosetta/Rosetta/main/source/bin/tmalign_cluster.boost_thread.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s ../frag_*.pdb -tmalign_cluster::cluster_radius 0.8 -j 20
# ~/git_rosetta/Rosetta/main/source/bin/tmalign_cluster.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s *_design_shift.pdb -tmalign_cluster::cluster_radius 0.8

#for k in $(/bin/ls c_*.pdb ); do echo $k | awk -F"_" '{print $2,$0}'; done | sort -k 1,1n
