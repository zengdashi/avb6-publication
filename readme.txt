Vall sequence numbering
~wangyr/scripts/frag_util/pdb2vall/database/rcsb_data/derived_data/pdb_seqres.txt


scp frag_*.pdb shilei@arlo:/Users/shilei/Documents/Research/Projects/InterfaceDesign/Integrin/Designs/Fragment_match_look_for_motif

#problems: some pdb is not right in naming
for x in frag_*.pdb; do n=`grep CA $x | wc -l`; echo $x $n ; done | sort -k 2,2n > pdb_size.output
awk '$NF!=25 {print "mv "$1,"pdb_has_wrong_numbering_from_vall"}' pdb_size.output  | bash

#run clustering and find out common motif

#number not from 1, inconsistent
/work/dekim/pdb/pdb/a0/1a0tP.pdb


/work/dekim/pdb/pdb/dr/3drfA.pdb


sed -n '/3drf_A/{n;p;}' ~wangyr/scripts/frag_util/pdb2vall/database/rcsb_data/derived_data/pdb_seqres.txt

#align pattern to complex pdb
~wangyr/bin/TMalign 1.pdb 2.pdb -m matrix.txt
#save matrix....
then do:
#perl /work/krypton/scripts/rot.pl matrix pdb > new_pdb
