% Open a plx file
% this will bring up the file-open dialog
StartingFileName = '/Ratos/R42/R42.plx';
%StartingFileName = 'c:\plexondata\NSSample.plx';
%StartingFileName = 'c:\plexondata\au101602a.plx';
[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreThresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(StartingFileName);

disp(['Opened File Name: ' OpenedFileName]);
disp(['Version: ' num2str(Version)]);
disp(['Frequency : ' num2str(Freq)]);
disp(['Comment : ' Comment]);
disp(['Date/Time : ' DateTime]);
disp(['Duration : ' num2str(Duration)]);
disp(['Num Pts Per Wave : ' num2str(NPW)]);
disp(['Num Pts Pre-Threshold : ' num2str(PreThresh)]);
% some of the information is only filled if the plx file version is >102
if ( Version > 102 )
    if ( Trodalness < 2 )
        disp('Data type : Single Electrode');
    elseif ( Trodalness == 2 )
        disp('Data type : Stereotrode');
    elseif ( Trodalness == 4 )
        disp('Data type : Tetrode');
    else
        disp('Data type : Unknown');
    end
        
    disp(['Spike Peak Voltage (mV) : ' num2str(SpikePeakV)]);
    disp(['Spike A/D Resolution (bits) : ' num2str(SpikeADResBits)]);
    disp(['Slow A/D Peak Voltage (mV) : ' num2str(SlowPeakV)]);
    disp(['Slow A/D Resolution (bits) : ' num2str(SlowADResBits)]);
end   



% get some counts
[tscounts, wfcounts, evcounts, slowcounts] = plx_info(OpenedFileName,1);

% tscounts, wfcounts are indexed by (unit+1,channel+1)
% tscounts(:,ch+1) is the per-unit counts for channel ch
% sum( tscounts(:,ch+1) ) is the total wfs for channel ch (all units)
% [nunits, nchannels] = size( tscounts )
% To get number of nonzero units/channels, use nnz() function

% gives actual number of units (including unsorted) and actual number of
% channels plus 1
[nunits1, nchannels1] = size( tscounts );   
nunits1
nchannels1

% we will read in the timestamps of all units,channels into a two-dim cell
% array named allts, with each cell containing the timestamps for a unit,channel.
% Note that allts second dim is indexed by the 1-based channel number.
% preallocate for speed
allts = cell(nunits1, nchannels1)


% get the a/d data into a cell array also.
% This is complicated by channel numbering.
% The number of samples for analog channel 0 is stored at slowcounts(1).
% Note that analog ch numbering starts at 0, not 1 in the data, but the
% 'allad' cell array is indexed by ich+1
numads = 0;
[u,nslowchannels] = size( slowcounts );   
if ( nslowchannels > 0 )
    % preallocate for speed
    allad = cell(1,nslowchannels);
    for ich = 0:nslowchannels-1
        if ( slowcounts(ich+1) > 0 )
			[adfreq, nad, tsad, fnad, allad{ich+1}] = plx_ad(OpenedFileName, ich);
			numads = numads + 1;
        end
    end
end

if ( numads > 0 )
    [nad,adfreqs] = plx_adchan_freqs(OpenedFileName);
    [nad,adgains] = plx_adchan_gains(OpenedFileName);
    [nad,adnames] = plx_adchan_names(OpenedFileName);

    % just for fun, plot the channels with a/d data
    iplot = 1;
    numPlots = min(4, numads);
    for ich = 1:nslowchannels
        [ nsamples, u ] = size(allad{ich});
        if ( nsamples > 0 )
            subplot(numPlots,1,iplot); plot(allad{ich});
            iplot = iplot + 1;
        end
        if iplot > numPlots
           break;
        end
    end
end