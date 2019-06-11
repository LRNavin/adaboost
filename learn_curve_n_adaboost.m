% Learning Curve Gen

n=[2 4 6 10 15 20];
        hold on

for i=1:size(n,2)
    data_str = strcat('n',num2str(n(i)));

    data = load(data_str);
    
    apparent_err_array = data.apparent_err_array;
    
    plot(apparent_err_array,'LineWidth',2)
    
end
    legend('n=2','n=4','n=6','n=10','n=15','n=20')

            hold off
            figure()
        hold on

for i=1:size(n,2)
    data_str = strcat('n',num2str(n(i)));
    hold on
    data = load(data_str);
    
    true_err_array = data.true_err_array;
    
        plot(true_err_array,'LineWidth',2)


end

    legend('n=2','n=4','n=6','n=10','n=15','n=20')

        hold off



