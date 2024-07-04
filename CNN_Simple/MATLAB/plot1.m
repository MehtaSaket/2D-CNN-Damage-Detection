% Classification error percentages for training and testing sets
training_error = 0.78125;
testing_error = 0.86806;

% Create a bar graph
bar_data = [training_error, testing_error];
labels = {'Training Set', 'Testing Set'};
bar(labels, bar_data);

% Set axis labels and title
xlabel('Dataset');
ylabel('Classification Error (%)');
title('Classification Error on Training and Testing Sets');

% Display the values on top of each bar
text(1:length(labels), bar_data, num2str(bar_data', '%.2f%%'), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

% Show the grid
grid on;

% Show the plot
