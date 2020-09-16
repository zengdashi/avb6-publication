#/bin/rm -f 7_filter_ddg_AlaInterface.joblist
#for k in $(/bin/ls fragments_extend_cluster*/part_continue_*.pdb)
#do
#echo "~/git_rosetta/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s $k -overwrite -nstruct 1 -parser:protocol toAla_ddg.xml" >> 7_filter_ddg_AlaInterface.joblist
#done
/bin/rm -f 7_filter_ddg_AlaInterface.sc
~/git_rosetta/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s fragments_extend_cluster*/align*.pdb -overwrite -nstruct 1 -parser:protocol toAla_ddg.xml -out:file:score_only 7_filter_ddg_AlaInterface.sc
#awk 'NF>2 {print $3,$NF}' 7_filter_ddg_AlaInterface.sc  | sort -k 1,1n

#~/git_rosetta/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -s fragments_extend_cluster1/aligned_c_0_6_part_continue_1_2c2jA_74_81.pdb -overwrite -nstruct 1 -parser:protocol toAla_ddg.xml
