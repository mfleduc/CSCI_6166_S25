%% CSCI 6166 HW 2 Problem 1
%
n=0:6;%Number of sides with a 1
for ii=0:6
    bincoeffsn(ii+1) = nchoosek(6,ii);
end
p_ngX = bincoeffsn.*((1/6).^n).*(5/6).^(6-n);
NN = [1,5,10,20,40];%Number of trials
posterior = cell(1,length(NN));
p_mgnN = cell(1,length(NN));
figure;
for jj = 1:length(NN)
    N = NN(jj);
    bincoeffsm = zeros(1,N+1);
    for ii=0:N
        bincoeffsm(ii+1) =  nchoosek(N,ii);
    end
    p_mgnN{jj} = bincoeffsm.*((n.'/6).^(0:N)).*((1-n.'/6).^(N:-1:0));
    %Randomly selecting a value of m
    condcdfs = cumsum( p_mgnN{jj},2) ./ sum( p_mgnN{jj},2 );
    u = rand([7,1]);
    mvals = zeros(7,1);
    for ii = 1:7
        mvals(ii,:) = find(u(ii,:)' < condcdfs(ii,:),1)'-1;
    end
    %%%%%%% Ask for clarification: Are we supposed to select m randomly and
    %%%%%%% then see how big $N$ needs to be for all of our estimates to
    %%%%%%% have a >99% certainty? Something related to E[m]?
    denom = sum( p_mgnN{jj}.*p_ngX',1 );
    numer = p_mgnN{jj}.*p_ngX';
    posterior{jj} = numer./denom; 
    % Previous line is p(n|m,N,X) along columns with N+1 columns (one for each possible value of m) 
    subplot(1,length(NN),jj);
    imagesc(0:N,n,posterior{jj});colorbar;caxis([0,1]);
    title(sprintf('N = %d',N));
    xlabel('m');ylabel('n');
end
sgtitle('p(n|m,N,X) for each value of N and m')
