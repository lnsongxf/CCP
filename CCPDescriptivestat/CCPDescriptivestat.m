clc
clear
load('CCPData.mat')
%% Sort CCs, calculate and plot correlation matrix
[b, ix]           = sort(nanmean(CC_CAP()), 'descend');
CC_RET_MAX        = CC_RET_wins(:,ix(1:11));
CC_TICK_MAX       = CC_TICK(:,ix(1:11));
[CORR,P]          = corrcoef([CC_RET_MAX, IND_RET]);
labelNames        = [upper(CC_TICK_MAX),IND_TICK]; 
pfig = imagesc(CORR);
set(gca, 'XTick', 1:size(CORR,1), 'YTick', 1:size(CORR,1),...
    'XTickLabel',labelNames, 'YTickLabel',labelNames, 'XTickLabelRotation',45);
title('Correlation of Top-10 CC and traditional assets')
colorbar;
saveas(pfig, strcat('CORR_IND_TOP_10CC','.fig'));
saveas(pfig, strcat('CORR_IND TOP_10CC','.pdf'));
saveas(pfig, strcat('CORR_IND TOP_10CC','.png'));
%% Save latex table with correlation coefficients for all constituents of the investment universe
input.data                      = round(CORR,2);
input.tableColLabels            = [CC_TICK_MAX, IND_TICK];
input.tableRowLabels            = [CC_TICK_MAX, IND_TICK];
input.transposeTable            = 0;
input.dataFormatMode            = 'column'; 
input.dataNanString             = '-';input.tableColumnAlignment      = 'r';
input.tableBorders              = 0;
input.tableCaption              = strcat('Correlation of CC and traditional assets');
input.makeCompleteLatexDocument = 0;
latex                           = latexTable(input);
%% Save latex table with descriptive statistics for all constituents of the investment universe
CC_IND_RET = [CC_RET_wins, IND_RET];
input.data                      = [arrayfun(@(j) max(CC_IND_RET(:,j)), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) quantile(CC_IND_RET(:,j), 0.9), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) quantile(CC_IND_RET(:,j), 0.5), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) mean(CC_IND_RET(:,j)), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) quantile(CC_IND_RET(:,j), 0.1), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) min(CC_IND_RET(:,j)), 1:size(CC_IND_RET,2));
                                   arrayfun(@(j) std(CC_IND_RET(:,j)), 1:size(CC_IND_RET,2))]';
                               
input.tableRowLabels            = [CC_TICK,IND_TICK];
input.tableColLabels            = {'maximum','upper percentile', 'median', 'mean',...
                                   'lower percentile','minimum', 'volatility'};
input.transposeTable            = 0;
input.dataFormatMode            = 'column'; 
input.dataFormat                = {'%.2f'};
input.dataNanString             = '-';
input.tableColumnAlignment      = 'c';
input.tableBorders              = 0;
input.tableCaption              = 'Descriptive statistics on continuously compounded monthly returns returns of satllites mutual funds';
input.tableLabel                = 'Table1';
input.makeCompleteLatexDocument = 1;
latex                           = latexTable(input);