%Optimal T finder for adaboost -> T from 1 to 100, 2 steps

% Input param -> [beta_T, hypothesis_T, hypothesis_Test]

apparent_err_array = [];
true_err_array     = [];

for t=1:1:200
    disp(t)
    
    % Classify Adaboost 
    
    current_beta_t              = beta_T(:,1:t);
    current_hypothesis_T        = hypothesis_T(:,1:t);
    current_hypothesis_Test     = hypothesis_Test(:,1:t);

    t_hypothesis_f        = logical( sum( (log(1./current_beta_t) .* current_hypothesis_T) ,2 )    >= (1/2) * sum( log(1./current_beta_t), 2) ); 
    t_hypothesis_f_test   = logical( sum( (log(1./current_beta_t) .* current_hypothesis_Test) ,2 ) >= (1/2) * sum( log(1./current_beta_t), 2) ); 

    
    t_err_bool_train  = logical(t_hypothesis_f ~= train_data(:,end));
    t_apparent_error = sum(t_err_bool_train)/size(t_err_bool_train,1);
    apparent_err_array = [apparent_err_array t_apparent_error]; 
    
    t_err_bool_test  = logical(t_hypothesis_f_test ~= test_data(:,end));
    t_test_error = sum(t_err_bool_test)/size(t_err_bool_test,1);
    true_err_array = [true_err_array t_test_error];
    
    
end

save('n4','apparent_err_array','true_err_array')

hold on
plot(apparent_err_array)
plot(true_err_array)
legend('Apparent Error', 'True Error')
hold off






