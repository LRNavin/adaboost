% train_data = load('/Users/navinLR/Desktop/MachineLearning/Assignments/Week-2/fashion57_test.txt');

% Gen Gauss Data - Norm Rand
% MODE - 0 -> Gauss data, 1 -> NIST,

% BOOST - 0 -> WeakLearn , 1 -> AdaBoost

boost = 0;
mode  = 0;
plots  = 1;
print = 1;

T = 200;

direction_array= ['L','R'];

if mode == 0
    plots  = 1;

    data_size  = 100;
%     mean_1 = [0 ; 0];
%     mean_2 = [2 ; 0];
% 
%     data_1 = mvnrnd(mean_1, [1 0; 0 1], data_size);
%     data_2 = mvnrnd(mean_2, [1 0; 0 1], data_size);
% 
%     data_1 = [data_1 zeros(size(data_1,1),1)];
%     data_2 = [data_2 ones(size(data_2,1),1)];
%     
%     train_data = [data_1 ; data_2];
%     
%     save('gauss_data','train_data')


data = load('gauss_data');
train_data = data.train_data;
% train_data(:, 2) = train_data(:,2)*15;
test_data = train_data;

else
    plots  = 0;
    
    
    trdata = dlmread('fashion57_train.txt');
    tsdata = dlmread('fashion57_test.txt');
    
%     n=2;
%     
%     r_1 = randi([1 32],1,n);
%     r_2 = randi([33 60],1,n);
    
    trdata_1 = [trdata(r_1,:) zeros(n,1)]; 
    trdata_2 = [trdata(r_2,:) ones(n,1)];
    
    tsdata_1 = [tsdata(1:195,:) zeros(195,1)]; 
    tsdata_2 = [tsdata(196:end,:) ones(205,1)];

    train_data = [trdata_1 ; trdata_2];
    test_data  = [tsdata_1 ; tsdata_2];

end

% w = zeros(size(train_data,1),1) + 1/size(train_data,1); % intial sample wieghts

if boost == 0
    % Only WeakLearn
    % Calculate Direction & Optimal Feature .....

    w = zeros(size(train_data,1),1) + 1/size(train_data,1); % intial sample wieghts

    optimal_feature   = 1;
    optimal_direction = 'L';
    optimal_theta     = 0;
    optimal_error     = size(train_data,1);

    for feat=1:size(train_data,2)-1
        for direct=1:size(direction_array,2)% check once for change
            [error, theta] = decision_stump(train_data(:,feat), train_data(:,end), w, direction_array(direct));
            if error < optimal_error
                optimal_error       = error;
                optimal_theta       = theta;
                optimal_feature     = feat;
                optimal_direction   = direction_array(direct);
            end
        end
    end


    if print
%         disp('feature')
%         disp(optimal_feature)
%         disp('direction')
%         disp(optimal_direction)
        disp('THETA')
        disp(optimal_theta)
        disp('Apparent error')
        disp(optimal_error/size(train_data,1))
    end

    if plots 

        hold on
            scatter(train_data(1:data_size,1), train_data(1:data_size,2), 'filled')
            scatter(train_data(data_size+1:end,1), train_data(data_size+1:end,2), 'filled')
            
%             text(train_data(1:data_size,1)+0.1,train_data(1:data_size,2)+0.1, num2str(index(train_data(1:data_size,1))));
%             text(train_data(data_size+1:end,1)+0.2,train_data(data_size+1:end,2)+0.2, num2str( 1:1:200 ));

            if optimal_feature == 1
                y_ax = floor(min(train_data(:,2))):ceil(max(train_data(:,2)));
                x_ax = zeros(1,size(y_ax,2)) + optimal_theta;
            else
                x_ax = floor(min(train_data(:,1))):ceil(max(train_data(:,1)));
                y_ax = zeros(1,size(x_ax,2)) + optimal_theta;
            end
            plot(x_ax , y_ax);
            legend('class - 0','class - 1','threshold')
        hold off

    end

    if mode == 1

        % Calculate Test Error / True Error , Apparent = optimal_error

        if(optimal_direction =='L')
            classify = logical(test_data(:,optimal_feature) < optimal_theta);
        else                
            classify = logical(test_data(:,optimal_feature) >= optimal_theta); 
        end

        err_bool  = logical(classify ~= test_data(:,end));

        true_error = sum(err_bool)/size(err_bool,1);


        disp('Apparent error')
        disp(optimal_error)
        disp('True error')
        disp(true_error)

    end

else
    % Boost WeakLearn
    % Pass - train_data, T (iter), p (sample wgt vec)
    [beta_T, hypothesis_T, hypothesis_Test] = adaboost(train_data(:,1:end-1), train_data(:,end), T, test_data(:,1:end-1));
    
    % Classify Adaboost 
    
    hypothesis_f        = logical( sum( (log(1./beta_T) .* hypothesis_T) ,2 )    >= (1/2) * sum( log(1./beta_T), 2) ); 
    hypothesis_f_test   = logical( sum( (log(1./beta_T) .* hypothesis_Test) ,2 ) >= (1/2) * sum( log(1./beta_T), 2) ); 

    
    err_bool_train  = logical(hypothesis_f ~= train_data(:,end));
    apparent_error = sum(err_bool_train)/size(err_bool_train,1);

    disp('Apparent error')
    disp(apparent_error)

    err_bool_test  = logical(hypothesis_f_test ~= test_data(:,end));
    test_error = sum(err_bool_test)/size(err_bool_test,1);

    disp('True error')
    disp(test_error)
    
end








