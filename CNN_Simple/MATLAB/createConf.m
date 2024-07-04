function createConf(trainTest,CDFNAME,FID,EXEDIR,CDFDIR,noITR,noRUNS,update,trRATE,lp,decay_lp,stop_ce,delta_mse,fs,ssx,cnnNol,mlpNol,frameSize,cnnStruct)
%This function creates a conf file for training
CDFDIR = strrep(CDFDIR, '\', '\\');

fid = fopen([EXEDIR 'CNNTestApp_conf.cnn'], 'w');
fprintf(fid,'item_no	0\n');
fprintf(fid,['dir		' CDFDIR ' \n']);
fprintf(fid,['title		' CDFNAME '\n']);
fprintf(fid,['id   ' num2str(FID) '\n']);

if trainTest == 0
    fprintf(fid,'btrain 	t\n');
else
    fprintf(fid,'btrain 	x\n');
end
fprintf(fid,'\n');
fprintf(fid,'# CNN training parameters:\n');
fprintf(fid,'##########################\n');
fprintf(fid,['no_iter   ' num2str(noITR) '\n']);
fprintf(fid,['no_runs   ' num2str(noRUNS) '\n']);
fprintf(fid,['update   ' num2str(update) '\n']);
fprintf(fid,['tr_rate   ' num2str(trRATE) '\n']);
fprintf(fid,['lp   ' num2str(lp) '\n']);
fprintf(fid,['decay_lp   ' num2str(decay_lp) '\n']);
fprintf(fid,['stop_ce   ' num2str(stop_ce) '\n']);
fprintf(fid,['delta_mse   ' num2str(delta_mse) '\n']);
fprintf(fid,'flags 	1 1 1 1\n');
fprintf(fid,'\n');
fprintf(fid,'# CNN conf. parameters:\n');
fprintf(fid,'#######################\n');
fprintf(fid,'ch_bias 0\n');
fprintf(fid,'in_size 1\n');
fprintf(fid,['fs   ' num2str(fs) '\n']);
fprintf(fid,['ssx   ' num2str(ssx) '\n']);
fprintf(fid,['ssy   ' num2str(ssx) '\n']);
fprintf(fid,'fn   0\n');
fprintf(fid,'ctype 0\n');
fprintf(fid,'ptype	 0\n');
fprintf(fid,['cnn_nol   ' num2str(cnnNol) '\n']);
fprintf(fid,['mlp_nol   ' num2str(mlpNol) '\n']);
fprintf(fid,['width   ' num2str(frameSize) '\n']);
fprintf(fid,['height   ' num2str(frameSize) '\n']);
fprintf(fid,'\n'); 
fprintf(fid,['min_non  ' cnnStruct '\n']);
fprintf(fid,['max_non  ' cnnStruct '\n']);

fclose(fid);

end

