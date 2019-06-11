% Adaboost Implementation - FreSch1995 notations

function [beta_T, hypothesis_T, hypothesis_Test] = adaboost(x, y, T, test_data)

    beta_T        = [];
    hypothesis_T  = [];
    hypothesis_Test = [];
    
    w_t = zeros(size(x,1),1) + 1/size(x,1); % intial sample wieghts

    for t=1:T
       
        w_t = w_t/sum(w_t); % Normalize sample weight
        
        % Weak Leaner for X->[0,1] for train and test data
        [hypothesis_t, hypothesis_test] = WeakLearn(x, y, w_t, test_data);

        e_t  = sum(w_t .* abs(hypothesis_t - y)); % Error of Hypothesis
        if e_t == 0
            e_t = 1;
        end

        % beta - adaptive t-th decision stump weight - update
        beta_t = e_t/(1-e_t);
        if beta_t == 0 || isinf(beta_t)
           beta_t = 1;
        end
        % Update Sample weights
        w_t = w_t .* (beta_t .^ (1 - abs(hypothesis_t - y)));

        beta_T          = [beta_T beta_t];
        hypothesis_T    = [hypothesis_T hypothesis_t];
        hypothesis_Test = [hypothesis_Test hypothesis_test];
        
    end
    
    disp(t)