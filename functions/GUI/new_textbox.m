function axesBox = new_textbox

f = figure('Visible','off','Units','pixels',...
           'Position',[650,350,460,420]);

axesBox = axes('Parent', f, 'Units','pixels',...
                      'XLim',[0 1],'Ylim',[0 1],'Box','on',...
                      'XTick',[],'YTick',[]);

                  
                  
f.Visible = 'on';
end

