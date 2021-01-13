#!/bin/bash
/bin/rm -f 2_extract_pdb.joblist
N=`wc -l frags.fsc.score.*.8mers | awk '{print $1}'`
mkdir -p shift_pdb alignment
for i in $(seq 2 1 $N)
do
	f=`echo $i-1 | bc`
	r1=`awk -v x=$i 'NR==x {print $2-8}' frags.fsc.score.*.8mers`
	e1=`awk -v x=$i 'NR==x {print $2+11}' frags.fsc.score.*.8mers`
	r2=`awk -v x=$i 'NR==x {print $2}' frags.fsc.score.*.8mers`
	e2=`awk -v x=$i 'NR==x {print $2+7}' frags.fsc.score.*.8mers`
	pdb=`awk -v x=$i 'NR==x {print $3}' frags.fsc.score.*.8mers`
	chain=`awk -v x=$i 'NR==x {print $4}' frags.fsc.score.*.8mers`
	rms=`awk -v x=$i 'NR==x {print $6}' frags.fsc.score.*.8mers`
	path=`awk -v x=$i 'NR==x {print "/work/dekim/pdb/pdb/"substr($3,2,2)"/"$3$4".pdb"}' frags.fsc.score.*.8mers`
	~/scripts/pdb2fasta.py $path > ${pdb}${chain}_pdb.fasta
	echo ">${pdb}_${chain}_pdbseq" >> ${pdb}${chain}_pdb.fasta
	sed -n "/${pdb}_${chain}/{n;p;}" ~wangyr/scripts/frag_util/pdb2vall/database/rcsb_data/derived_data/pdb_seqres.txt >> ${pdb}${chain}_pdb.fasta

        #find out aligned and unaligned regions
        ~/bin/muscle3.8.31_i86linux64 -in ${pdb}${chain}_pdb.fasta -quiet -out ${pdb}${chain}_pdb.alignment

	#sequence of protein
	restartres=`sed -e '/pdbseq/,$d' ${pdb}${chain}_pdb.alignment | awk 'NR>1' | tr '\n' ' ' | sed 's/ //g' | fold -w1 |  sed '/[A-Z]/,$d' | wc -l | awk '{print $1+1}'`
	~dekim/src/pdbUtil/shiftPdbResSeq.pl -pdbfile $path -res1 $restartres > shift_pdb/${pdb}${chain}_shift.pdb
	mv ${pdb}${chain}_pdb.alignment ${pdb}${chain}_pdb.fasta alignment
	
	echo "~/scripts/pdb_extract_start_end.py shift_pdb/${pdb}${chain}_shift.pdb $r1 $e1 > frag_${f}_${pdb}${chain}_${r2}_${e2}_${rms}.pdb" >> 2_extract_pdb.joblist
	echo "~/scripts/pdb_extract_start_end.py shift_pdb/${pdb}${chain}_shift.pdb $r2 $e2 > fragonly_${f}_${pdb}${chain}_${r2}_${e2}_${rms}.pdb" >> 2_extract_pdb.joblist

done
#awk 'NR>1 && $7<=0.8 {print "~/scripts/pdb_extract_start_end.py /work/dekim/pdb/pdb/"substr($3,2,2)"/"$3$4".pdb",$2-8,$2+7+4,"> frag_"NR-1"_"$3$4"_"$2"_"$2+7"_"$6".pdb"}' frags.fsc.score.*.8mers > 2_extract_pdb.joblist
#mv frag_*.pdb fragments_extend_extract
