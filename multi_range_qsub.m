function output_struct=multi_range_qsub(stringa,stringa_mfile,par)

%This function creates all the jobs that will be submitted to the cluster

subvect=par.subvect;
par=rmfield(par,'subvect');

for iSub=1:length(subvect)
    Sub=subvect{iSub};
    par.subvect=subvect(iSub);
    stringa_dir=[stringa  '_' Sub];
    output_struct=write_m_file(stringa_dir,stringa_mfile,par);
end


for iSub=1:length(subvect)
    Sub=subvect{iSub};
    comm=['matlab -noopengl < script_' stringa  '_' Sub '.m > output_file_script_' stringa  '_' Sub]; % without using Xvfb, -noopengl
    script_name=[stringa  '_' Sub '_slurmscriptfile'];
    write_qsubscript_slurm_axon(script_name,comm);

end

script_name=[stringa '_submit.sh'];
fid = fopen(script_name,'w');
for iSub=1:length(subvect)
    Sub=subvect{iSub};
    fprintf(fid,['sbatch ' stringa  '_' Sub '_slurmscriptfile\n']);
end
fclose(fid);
unix(['chmod +x ' script_name]);

