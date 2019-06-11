% Weak Learn - Hypothesis X -> [0, 1]

function [hypothesis_t, hypothesis_test] = WeakLearn(x, y, w_t, test_data)

    direction_array = ['L','R'];
    optimal_error   = size(x,1);

    % Calculate Direction & Optimal Feature .....
    for feat=1:size(x,2)
        for direct=1:size(direction_array,2)
            [error, theta] = decision_stump(x(:,feat), y, w_t, direction_array(direct));
            if error <= optimal_error
                optimal_error       = error;
                optimal_theta       = theta;
                optimal_feature     = feat;
                optimal_direction   = direction_array(direct);
            end
        end
    end

    % Classify & Calculate Error - Train Data
    if(optimal_direction =='L')
        hypothesis_t = logical(x(:,optimal_feature) < optimal_theta);
    else                
        hypothesis_t = logical(x(:,optimal_feature) >= optimal_theta); 
    end
    
    % Classify & Calculate Error - Test Data
    if(optimal_direction =='L')
        hypothesis_test = logical(test_data(:,optimal_feature) < optimal_theta);
    else                
        hypothesis_test = logical(test_data(:,optimal_feature) >= optimal_theta); 
    end