function printFigureToPdf(fileName, figureSize, units, extraSpace, figHandle)
	% printFigureToPdf(fileName, figureSize, units, figHandle)
	%
	% Outputs a pdf of the figure where all the extra whitespace has been
	% cropped out.  The paper size in the pdf will match the size of the
	% figure as well.  Note that having a suptitle in the figure seems to
	% mess up the part of this function that sets tight margins.
	%	fileName - The name of the pdf file to create, e.g. 'fig.pdf'
	%	figureSize - The size of the figure, e.g. [6.5 4]
	%	units - The units used for figureSize, e.g. 'inches'
	%	extraSpace - Optional parameter.  The amount of extra space (in
	%		normalized units) to put on the left, bottom, right, and top
	%		sides of the graph.  Use this if something is getting cut off.
	%		The format is [leftSpace, bottomSpace, rightSpace, topSpace].
	%		So, [.1, .1, .1, .1] would put 10% extra space on all sides.
	%		If [] is passed in, the default [0 0 0 0] will be used.
	%	figHandle - Optional parameter.  The handle to the figure to output
	%		to a pdf.  If omitted, gcf will be used.
	
	if(nargin < 4 || isempty(extraSpace))
		extraSpace = [0 0 0 0];
	end	
	if(nargin < 5)
		figHandle = gcf;
	end
	
	% Store the old state so it can be restored
	axisHandle = get(figHandle, 'CurrentAxes');
	oldLooseInset = get(axisHandle, 'LooseInset');
	oldPaperUnits = get(figHandle, 'PaperUnits');
	oldPaperSize = get(figHandle, 'PaperSize');
	oldPaperPositionMode = get(figHandle, 'PaperPositionMode');
	oldPaperPosition = get(figHandle, 'PaperPosition');
	oldRenderer = get(figHandle, 'renderer');
	
	% Eliminate extra whitespace in the figure
	set(axisHandle, 'LooseInset', get(axisHandle, 'TightInset') + extraSpace);

	% Set up the paper size / position
	set(figHandle, 'PaperUnits', units);
	set(figHandle, 'PaperSize', figureSize);    % Set to final desired size here as well as 2 lines below
	set(figHandle, 'PaperPositionMode', 'manual');
	set(figHandle, 'PaperPosition', [0 0 figureSize]);

	% To guarantee vector graphics output (doesn't support transparency though)
	set(figHandle, 'renderer', 'painters');

	% Output the figure
	print(figHandle, '-dpdf', fileName);
	
	% Restore previous state
	set(axisHandle, 'LooseInset', oldLooseInset);
	set(figHandle, 'PaperUnits', oldPaperUnits);
	set(figHandle, 'PaperSize', oldPaperSize);
	set(figHandle, 'PaperPositionMode', oldPaperPositionMode);
	set(figHandle, 'PaperPosition', oldPaperPosition);
	set(figHandle, 'renderer', oldRenderer);
end