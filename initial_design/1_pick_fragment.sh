~/git_rosetta/Rosetta/main/source/bin/fragment_picker.default.linuxgccrelease @flags_picker
# 运行fragment_picker.default.linuxgccrelease工具，使用flags_picker文件内的参数作为输入
~/git_rosetta/Rosetta/main/source/bin/fragment_picker.boost_thread.linuxgccrelease @flags -j 10

~/git_rosetta/Rosetta/main/source/bin/extract_pdbs.default.linuxgccrelease -database ~/git_rosetta/Rosetta/main/database/ -in:file:silent avb6B.fasta.frags.*.8mers.out

vall pdbs in /work/dekim/pdb/pdb

