\NeedsTeXFormat{LaTeX2e}


%%%%%%%%%%%%%%%%%%%%%
% CLASS DECLARATION %
%%%%%%%%%%%%%%%%%%%%%

% Class providing
\ProvidesClass{cv}

% Class heritage (beamer class)
\LoadClass{beamer}
	\beamertemplatenavigationsymbolsempty % Remove navigation bar
	\addtolength{\headsep}{0.0cm} 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Pkg
\RequirePackage{xcolor}
\usefonttheme{serif}
\RequirePackage{tikz}
	\usetikzlibrary{arrows.meta, calc, chains, shapes.misc, positioning}
\RequirePackage{calc}
\RequirePackage{geometry}
	\geometry{margin=0pt, paper=a4paper} % DIN A4
\RequirePackage{xparse}
\RequirePackage{ifthen}
\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{cvthirdparties}
\RequirePackage{pdfcomment}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




















%%%%%%%%%%%%%%%%%%%%%
% PRIVATE VARIABLES %
%%%%%%%%%%%%%%%%%%%%%

% Local page allocable bounding box
\newlength\page@bb@x
\newlength\page@bb@y
\newlength\page@bb@w
\newlength\page@bb@h
\newcommand{\set@page@bb}[4]{
	\setlength{\page@bb@x}{#1}
	\setlength{\page@bb@y}{#2}
	\setlength{\page@bb@w}{#3}
	\setlength{\page@bb@h}{#4}
	\global\page@bb@x=\page@bb@x
	\global\page@bb@y=\page@bb@y
	\global\page@bb@w=\page@bb@w
	\global\page@bb@h=\page@bb@h
	}
\newcommand{\add@page@bb}[4]{
	\set@page@bb{\page@bb@x + #1}{\page@bb@y + #2}{\page@bb@w + #3}{\page@bb@h + #4}
	}

% Local layout allocable bounding box (x for horizontal leyout, y for vertical layout)
\newlength\layout@bb@x
\newlength\layout@bb@y
\newlength\layout@bb@w
\newlength\layout@bb@h
\newcommand{\set@layout@bb}[4]{
	\setlength{\layout@bb@x}{#1}
	\setlength{\layout@bb@y}{#2}
	\setlength{\layout@bb@w}{#3}
	\setlength{\layout@bb@h}{#4}
	\global\layout@bb@x=\layout@bb@x
	\global\layout@bb@y=\layout@bb@y
	\global\layout@bb@w=\layout@bb@w
	\global\layout@bb@h=\layout@bb@h
	}
\newcommand{\add@layout@bb}[4]{
	\set@layout@bb{\layout@bb@x + #1}{\layout@bb@y + #2}{\layout@bb@w + #3}{\layout@bb@h + #4}
	}

% Other
\newboolean{myboolean}
\newcounter{mycounter}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%
% LAYOUT/PAGE %
%%%%%%%%%%%%%%%

% \begin{page}
\newenvironment{page}{

	% Set page bounding box
	\set@page@bb{0pt}{0pt}{\paperwidth}{\paperheight}
		
	% Tikzpicture environment for full page
	\begin{frame}
		\tikzpicture
	}{
		\endtikzpicture
	\end{frame}
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \begin{layout}
\pgfkeys{
	/layout/.cd,
		% Store in...
		size/.store in = \layout@size, % Characteristical size (width or height depending align)
		anchor/.store in = \layout@anchor, % Alignment inside the paper (north, south, east, west)
		fill/.store in = \layout@fill, % Background color of the layout
		left margin/.store in = \layout@leftMargin,     % Margin left
		right margin/.store in = \layout@rightMargin,   % Margin right
		top margin/.store in = \layout@topMargin,       % Margin top
		bottom margin/.store in = \layout@bottomMargin, % Margin bottom
		tooltip box size/.store in = \layout@tooltip@box@size, % Tooltip box size
		% Default...	
		size = 0, % size = 0 aims for paperfill
		anchor = west,
		fill = yellow,
		left margin = 5mm,
		right margin = 5mm,
		top margin = 5mm,
		bottom margin = 5mm,
		tooltip box size = 60mm,
	}
\newenvironment{layout}[1][]{
	
	% Load variables from environment
	\pgfkeys{/layout/.cd, #1}
		
	% Bounding box (background)
	\ifthenelse{\equal{\layout@anchor}{east}}{
		
		% Set layout bounding box
		\set@layout@bb{\page@bb@x+\page@bb@w-\layout@size}{\page@bb@y}{\layout@size}{\page@bb@h}
		
		% Carriage the bounding box
		\add@page@bb{0pt}{0pt}{-\layout@size}{0pt}
		
		% Create bounding box
		\node [inner sep = 0, anchor = north west, fill = \layout@fill, minimum width = \layout@size, minimum height = \layout@bb@h] at (\layout@bb@x,\layout@bb@y) {};
						
		}{}
	
	\ifthenelse{\equal{\layout@anchor}{west}}{
	
		% Size = 0 means full page
		\ifthenelse{\equal{\layout@size}{0}}{ \pgfkeys{/layout/.cd, size = \page@bb@w} }{}
		
		% Set layout bounding box
		\set@layout@bb{\page@bb@x}{\page@bb@y}{\layout@size}{\page@bb@h}
		
		% Carriage the bounding box
		\add@page@bb{\layout@size}{0pt}{-\layout@size}{0pt}
		
		% Create bounding box
		\node [inner sep = 0, anchor = north west, fill = \layout@fill, minimum width = \layout@size, minimum height = \layout@bb@h] at (\layout@bb@x, \layout@bb@y) {};
		
		}{}
	
	\ifthenelse{\equal{\layout@anchor}{north}}{
	
		% Size = 0 means full page
		\ifthenelse{\equal{\layout@size}{0}}{ \pgfkeys{/layout/.cd, size = \page@bb@h} }{}
		
		% Set layout bounding box
		\set@layout@bb{\page@bb@x}{\page@bb@y}{\page@bb@w}{\layout@size}
		
		% Carriage the bounding box
		\add@page@bb{0pt}{-\layout@size}{0pt}{-\layout@size}
		
		% Create bounding box
		\node [inner sep = 0, anchor = north west, fill = \layout@fill, minimum width = \layout@bb@w, minimum height = \layout@size] at (\layout@bb@x, \layout@bb@y) {};

		}{}
	
	\ifthenelse{\equal{\layout@anchor}{south}}{
	
		% Size = 0 means full page
		\ifthenelse{\equal{\layout@size}{0}}{ \pgfkeys{/layout/.cd, size = \page@bb@h} }{}
		
		% Set layout bounding box
		\set@layout@bb{\page@bb@x}{\page@bb@y-\page@bb@h+\layout@size}{\page@bb@w}{\layout@size}
		
		% Carriage the bounding box
		\add@page@bb{0pt}{0pt}{0pt}{-\layout@size}
		
		% Create bounding box
		\node [inner sep = 0, anchor = north west, fill = \layout@fill, minimum width = \layout@bb@w, minimum height = \layout@size] at (\layout@bb@x, \layout@bb@y) {};

		}{}
		
	% Top left margin and text area
	\add@layout@bb{\layout@leftMargin}{-\layout@topMargin}{-\layout@leftMargin-\layout@rightMargin}{-\layout@topMargin-\layout@bottomMargin}
		
	}{
	

	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%
% WIDGETS %
%%%%%%%%%%%

% widget keys
\pgfkeys{
	/widget/.cd,
		% Store in...
		left margin/.store in = \wgt@leftMargin,       % Margin left
		right margin/.store in = \wgt@rightMargin,     % Margin right
		top margin/.store in = \wgt@topMargin,         % Margin top
		bottom margin/.store in = \wgt@bottomMargin,   % Margin bottom
		chain distance/.store in = \wgt@chainDistance, % Margin bottom
		draw/.store in = \wgt@draw,                    % Line color
		fill/.store in = \wgt@fill,                    % Fill color
		empty/.store in = \wgt@empty,                  % Empty color
		background/.store in = \wgt@background,        % Background color
		text/.store in = \wgt@text,                    % Text color
		align/.store in = \wgt@align,                  % Alignment (usually text)
		minimum height/.store in = \wgt@minimumHeight, % Minimum height
		minimum width/.store in = \wgt@minimumWidth,   % Minimum width
		bubble/.store in = \wgt@bubble,                % Bubble color
		icon/.store in = \wgt@icon,                    % Icon color
		tooltip box width/.store in = \wgt@tooltip@box@width, % Tooltip box width
		tooltip box background/.store in = \wgt@tooltip@box@bkg, % Tooltip box color
		tooltip box frame/.store in = \wgt@tooltip@box@frm, % Tooltip box draw color
		% Ignore margins
		private expand layout/.store in = \pvt@wgt@expandLayout, % Layout bounds ignored
		private expand layout = 0,
		expand layout/.code = { \renewcommand{\pvt@wgt@expandLayout}{1} }, % Layout bounds ignored
		% Default...	
		left margin = 0mm,
		right margin = 0mm,
		top margin = 1mm,
		bottom margin = 1mm,
		chain distance = 4mm,
		draw = white,
		fill = none,
		empty = none,
		background = none,
		text = black!90,
		align = center,
		minimum height = 0.0cm,
		minimum width = 0.0cm,
		bubble = red,
		icon = darkgray,
		tooltip box width = 60mm,
		tooltip box background = cyan!10,
		tooltip box frame = black!90,
	}
\newcommand{\wgt@reset}{ % Reset to default, use always at the end of a widget
	\pgfkeys{/widget/private expand layout = 0}
	\pgfkeys{/widget/left margin = 0mm}
	\pgfkeys{/widget/right margin = 0mm}
	\pgfkeys{/widget/top margin = 1mm}
	\pgfkeys{/widget/bottom margin = 1mm}
	\pgfkeys{/widget/chain distance = 4mm}
	\pgfkeys{/widget/draw = white}
	\pgfkeys{/widget/fill = none}
	\pgfkeys{/widget/empty = none}
	\pgfkeys{/widget/background = none}
	\pgfkeys{/widget/text = black!90}
	\pgfkeys{/widget/align = center}
	\pgfkeys{/widget/minimum height = 0.0cm}
	\pgfkeys{/widget/minimum width = 0.0cm}
	\pgfkeys{/widget/bubble = white}
	\pgfkeys{/widget/icon = white}
	\pgfkeys{/widget/tooltip box width = 60mm}
	\pgfkeys{/widget/tooltip box background = cyan!10}
	\pgfkeys{/widget/tooltip box frame = black!90}
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% bubble keys
\pgfkeys{
	/bubble/.cd,
		% Store in...
		fill/.store in = \bub@fill,                           % Fill color
		empty/.store in = \bub@empty,                         % Empty color
		background/.store in = \bub@background,               % Background color
		icon/.store in = \bub@icon,                           % Icon color
		tooltip box width/.store in = \bub@tooltip@box@width, % Tooltip box width
		minimum height/.store in = \bub@minimumHeight, % Minimum height
		% Default...	
		fill = cyan,
		empty = gray,
		background = none,
		icon = white,
		tooltip box width = 60mm,
		minimum height = 0mm,
	}
\newcommand{\bub@reset}{ % Reset to default, use always at the end of a widget
	\pgfkeys{/bubble/fill = none}
	\pgfkeys{/bubble/empty = none}
	\pgfkeys{/bubble/background = none}
	\pgfkeys{/bubble/icon = none}
	\pgfkeys{/bubble/tooltip box width = 60mm}
	\pgfkeys{/bubble/minimum height = 0mm}
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \wgtVSpace[
%	bottom margin = ?, top margin = ?,
%	]{height}
\newcommand{\wgtVSpace}[2][]{

	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
		
	% Add it directly to the layout
	\add@layout@bb{0pt}{-#2-\wgt@topMargin-\wgt@bottomMargin}{0pt}{-#2-\wgt@topMargin-\wgt@bottomMargin}
	
	% Recover defaults
	\wgt@reset%
	
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \wgtHSeparator[
%	left margin = ?, right margin = ?, bottom margin = ?, top margin = ?,
%	expand layout?
%	]
\newcommand{\wgtHSeparator}[1][]{

	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
		
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}
	
	% Draw line separator
	\draw [\wgt@draw] (\layout@bb@x+\wgt@leftMargin-\pvt@wgt@expandLayout * \layout@leftMargin, \layout@bb@y)--++(\layout@bb@w-\wgt@leftMargin-\wgt@rightMargin+\pvt@wgt@expandLayout * \layout@leftMargin+\pvt@wgt@expandLayout * \layout@rightMargin,0);
	
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
	
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \wgtText[
%	left margin = ?, right margin = ?, bottom margin = ?, top margin = ?,
%	fill = ?, align = ?, minimum height = ?,
%	expand layout?
%	]{text}
\newcommand{\wgtText}[2][]{

	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
		
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}
	
	% Text block
	\node [anchor = north west, inner sep = 0pt, fill = \wgt@fill, align = \wgt@align, text width = \layout@bb@w-\wgt@leftMargin-\wgt@rightMargin+\pvt@wgt@expandLayout * \layout@leftMargin+\pvt@wgt@expandLayout * \layout@rightMargin, minimum height = \wgt@minimumHeight] (tmp) at (\layout@bb@x+\wgt@leftMargin-\pvt@wgt@expandLayout * \layout@leftMargin, \layout@bb@y) {\textcolor{\wgt@text}{#2}};
	
	% Add height to the layout
	\path (tmp.south west); \pgfgetlastxy{\tmpX}{\tmpY};
	\set@layout@bb{\layout@bb@x}{\tmpY}{\layout@bb@w}{\layout@bb@h}
	
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
	
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \wgtPhotoAndContact[
%	bottom margin = ?, top margin = ?,
%	bubble = ?,
%	expand layout?                                       <----------------------
%	]{photo}{bubbles}
\NewDocumentCommand{\wgtPhotoAndContact}{
	O{} % pgfkeys input
	m % photo path
	D(){90} % bubbles start angle
	D(){360} % bubbles maximum angle
	m % bubbles
	}{
	
	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}

	% Reserve space
	\node [inner sep = 0, anchor=north west, align=center, minimum width = \layout@bb@w, minimum height = \layout@bb@w] (photoNode) at (\layout@bb@x, \layout@bb@y) { };
		
	% Draw photo
	\node [inner sep = 0, circle, draw=white, line width=2pt, minimum width=0.55\layout@bb@w, path picture={\node at (path picture bounding box.center) {\includegraphics[width=0.55\layout@bb@w]{#2}};}] at (photoNode.center) {};
		
	% Count number of bubbles
	\setcounter{mycounter}{0}; \@for\tmp:=#5\do{ \stepcounter{mycounter} }
	
	% Draw bubbles
	\foreach \bubble [count=\bubblei] in #5 {
		\node at ($(photoNode.center)+( #3 + \bubblei * #4 / \themycounter : 0.4 * \layout@bb@w )$) {\bubble};
		}
	
	% Add height to the layout
	\path (photoNode.south west); \pgfgetlastxy{\tmpX}{\tmpY};
	\set@layout@bb{\layout@bb@x}{\tmpY}{\layout@bb@w}{\layout@bb@h}
		
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
	
	}
% itmPhotoAndContactBubble{href}{icon}
\newcommand\itmPhotoAndContactBubble[2]{
	\href{#1}{\textcolor{\wgt@bubble}{\includegraphics[width=0.15\layout@bb@w]{#2}}}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% wgtIconAndText[
%	minimum height = ?, icon = ?,
%	]{href}{icon}
\newcommand\wgtIconAndText[3][]{
		
	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}

	% Draw
	#3 \fontsize{\f@size}{\f@size}\selectfont
	\node [inner sep = 0, minimum height = \wgt@minimumHeight, text width=\layout@bb@w, anchor=north west, align=left] (tmpNode) at (\layout@bb@x, \layout@bb@y) {\textcolor{\wgt@icon}{ \raisebox{-0.15 em}{ \includegraphics[height=\f@size pt]{#2}} \textcolor{\wgt@text}{#3}} };
	\normalsize
	
	% Add height to the layout
	\path (tmpNode.south west); \pgfgetlastxy{\tmpX}{\tmpY};
	\set@layout@bb{\layout@bb@x}{\tmpY}{\layout@bb@w}{\layout@bb@h}
	
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
		
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% itmTextAndHorizontalProgress[
%	
%	]{text}{value from 0 to 100}
\newcommand\itmTextAndHorizontalProgress[3][]{
		
	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}

	% Text
	\node [inner sep = 0, minimum height = \wgt@minimumHeight, text width=\layout@bb@w, anchor=north west, align=left] (tmpNode) at (\layout@bb@x, \layout@bb@y) {\textcolor{\wgt@text}{#2} };
	
	% Progress
	\ifthenelse{\equal{#3}{100} \OR \equal{#3}{100.0} \OR \equal{#3}{100.00}}{}{
		\node [very thick, draw = \wgt@empty, rounded corners=1mm, fill=\wgt@empty, inner sep = 0, minimum height = \f@size / 2, text width=0.7\layout@bb@w, anchor=north west, align=left] at (\layout@bb@x + 0.3\layout@bb@w, \layout@bb@y) {  };
		}
	\ifthenelse{\equal{#3}{0} \OR \equal{#3}{0.0} \OR \equal{#3}{0.00}}{}{
		\node [very thick, draw = \wgt@empty, rounded corners=1mm, fill=\wgt@fill, inner sep = 0, minimum height = \f@size / 2, text width=0.7 * #3 / 100 * \layout@bb@w, anchor=north west, align=left] (tmpNode) at (\layout@bb@x+0.3\layout@bb@w, \layout@bb@y) {  };
		}
	
	
	% Add height to the layout
	\path (tmpNode.south west); \pgfgetlastxy{\tmpX}{\tmpY};
	\set@layout@bb{\layout@bb@x}{\tmpY}{\layout@bb@w}{\layout@bb@h}
	
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
		
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% wgtDialRow[
%	
%	]{ {text01/icon01/progress01/comment01, text02/icon02/progress02/comment02, ...} }
\NewDocumentCommand{\wgtDialRow}{
	O{} % pgfkeys input
	m % bubbles
	}{
		
	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}
	
	% Count number of bubbles
	\setcounter{mycounter}{0}; \foreach \bubble in #2 { \stepcounter{mycounter} }
	
	% Final node (layout y reference)
	\node (finalNode) at (\layout@bb@x, \layout@bb@y - \wgt@minimumHeight) {};
	
	% For each bubble
	\foreach \text/\icon/\progress/\comment [count=\bubblei] in #2 {
	
		% Draw progress
		\node [inner sep = 0, anchor = north west, minimum width = \layout@bb@w / \themycounter, minimum height = \wgt@minimumHeight, path picture = {\bubDial[minimum height = \wgt@minimumHeight, empty = \wgt@empty, fill = \wgt@fill, icon = \wgt@icon]{\icon}{\progress}}] (bubbleNode) at (\layout@bb@x + \layout@bb@w - \bubblei * \layout@bb@w / \themycounter, \layout@bb@y) {};
		
		\ifthenelse{ \equal{\comment}{} }{}{
			\node [inner sep = 0, anchor = center] at (bubbleNode) { \tooltip[background = \wgt@tooltip@box@bkg, frame = \wgt@tooltip@box@frm]{\fontsize{\wgt@minimumHeight}{\wgt@minimumHeight}\selectfont\phantom{A}}{\normalsize{\comment}} };
			}
		
		% Draw text
		\node [text height = \f@size, inner sep = 0, minimum height = \f@size, anchor = north west, align = center, text width = \layout@bb@w / \themycounter] (bubbleTextNode) at ($(bubbleNode.south west)+(0,-1mm)$) {  \textcolor{\wgt@text}{\text} };
    
		% Text detected! TODO : detect which box is the biggest
		\ifthenelse{ \equal{\text}{} }{}{
			\node (finalNode) at (bubbleTextNode.south west) {};
			}
		
		}
			
	% Add height to the layout
	\path (finalNode.south west); \pgfgetlastxy{\tmpX}{\tmpY};
	\set@layout@bb{\layout@bb@x}{\tmpY}{\layout@bb@w}{\layout@bb@h}
	
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%
		
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \bubDial[
%	
%	]{icon_path}{dial_progress}{mouse_over_tooltip}{href_on_click}
\NewDocumentCommand{\bubDial}{
	O{} % PGFkeys
	m   % Icon
	m   % Dial progress (in %)
	}{

	% Load variables from environment
	\pgfkeys{/bubble/.cd, #1}
	
	% Variable color (vs %)
	\colorlet{progresscolor}{lime!#3!yellow!#3!red}
	
	% Draw progress
	\draw [draw = none, fill = \bub@empty] (path picture bounding box.center) circle (\bub@minimumHeight / 2);
	\draw [draw = none, fill = progresscolor] (path picture bounding box.center)--([shift=(90:\bub@minimumHeight / 2)]0,0) arc (90:90 + #3 * 3.60:\bub@minimumHeight / 2 + 0.01mm)--cycle;
	\draw [draw = none, fill = progresscolor] (90:0.89 * \bub@minimumHeight / 2) circle (\bub@minimumHeight * 0.055);
	\draw[draw = none, fill = progresscolor] (90+#3 * 3.60:0.89 * \bub@minimumHeight / 2) circle (\bub@minimumHeight * 0.055);
	
	% Draw icon
	\draw [draw = none, fill = \layout@fill] (path picture bounding box.center) circle (\bub@minimumHeight / 2 * 0.775);
	\pgfdeclareimage[width=\bub@minimumHeight]{A}{#2};
	\node [anchor = center] at (path picture bounding box.center) {\textcolor{\bub@icon}{\scalebox{0.775}{\pgfuseimage{A}}}};
			
	% Recover defaults
	\bub@reset%
	
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% wgtVTimeline[
%	chain distance = ?,
%	]{ {year01/title/text/comment} }
\NewDocumentCommand{\wgtVTimeline}{
	O{} % pgfkeys input
	m % timeline items
	}{
	
	% Private variables
	\def\pvt@text@reserved{0.9} % text percentage
	\def\pvt@dot@position{0.08} % text percentage
	
	\tikzset{
		dot/.style = {circle, very thick, fill=gray, minimum size=2mm, inner sep=0pt, outer sep=0pt},
		}

	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	% Add a space before
	\add@layout@bb{0pt}{-\wgt@topMargin}{0pt}{0pt}
	\add@layout@bb{0pt}{-2mm}{0pt}{0pt}
	
	% Count number of entries
	\setcounter{mycounter}{0}; \foreach \entry in #2 { \stepcounter{mycounter} }

	% For each entry
	\foreach \year/\title/\text [count=\entryi] in #2 {
	
		% Remember title text size
		% BUG? \title
		
		% Dot
		\node [inner sep = 0, anchor = north west] (dotAuxNode) at (\layout@bb@x + \pvt@dot@position * \layout@bb@w, \layout@bb@y) {\phantom{A}};
		\node [inner sep = 0, circle, very thick, fill = \wgt@draw, minimum size = 2mm, inner sep = 0pt, outer sep = 0pt] (dot-\entryi) at (dotAuxNode.west) {}; \node (dot-end) at (dotAuxNode.west) {};
		
		% Reset fontsize
		\normalsize
		
		% Year
		\node [inner sep = 0, align = right, left = 1mm of dotAuxNode.west] (yearNode) {\year~};
		
		% Text
		\node [inner sep = 0, anchor = north west, text width = \pvt@text@reserved * \layout@bb@w-\wgt@rightMargin, align = justify] (textNode) at (\layout@bb@x + \layout@bb@w - \pvt@text@reserved * \layout@bb@w, \layout@bb@y) { {\title} \hfill \\ \text };
		
		% Add height to the layout
		\path (textNode.south west); \pgfgetlastxy{\tmpX}{\tmpY};
		\set@layout@bb{\layout@bb@x}{\tmpY-\wgt@chainDistance}{\layout@bb@w}{\layout@bb@h}
	
		}
	
	% Draw chain line
	\draw [draw = \wgt@draw, very thick] (dot-1.center)--(dot-end.center);
	\draw [draw = \wgt@draw, very thick, -latex] (dot-1.center)--++(0,+4mm);
	\draw [draw = \wgt@draw, very thick, -{Circle[length=1mm]}] (dot-end.center)--(dot-end.center |- textNode.west);
		
	% Add a space after
	\add@layout@bb{0pt}{-\wgt@bottomMargin}{0pt}{0pt}
	
	% Recover defaults
	\wgt@reset%

	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcommand\wgtRightRounded[2][]{

	% Load variables from environment
	\pgfkeys{/widget/.cd, #1}
	
	\node (n1) at (\layout@bb@x - #2 + \layout@rightMargin + \layout@bb@w + 0.55mm, #2 + \layout@bb@y - \wgt@topMargin - 0.55mm) {};
	
	\draw [draw = \wgt@fill, fill = \wgt@fill, line width = 1mm]
		($([shift=(-90:#2)]0,0)+(n1)$) arc (-90:0:#2)
		 --++ (0,-#2)-- cycle;
			
	% Recover defaults
	\wgt@reset%
	
	}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcommand{\txtCourseraDifficulty}[1]{
	\ifthenelse{\equal{#1}{1}}{
		\raisebox{-0.1em}{
			\begin{tikzpicture}
				\draw [draw = none, fill = cyan] (0ex,0ex) rectangle (0.5ex, 0.75ex);
				\draw [draw = none, fill = none]  (1ex,0ex) rectangle (1.5ex, 1.25ex);
				\draw [draw = none, fill = none]  (2ex,0ex) rectangle (2.5ex, 1.75ex);
			\end{tikzpicture}
			}
		}{}
	\ifthenelse{\equal{#1}{2}}{
		\raisebox{-0.1em}{
			\begin{tikzpicture}
				\draw [draw = none, fill = green] (0ex,0ex) rectangle (0.5ex, 0.75ex);
				\draw [draw = none, fill = green]  (1ex,0ex) rectangle (1.5ex, 1.25ex);
				\draw [draw = none, fill = none]  (2ex,0ex) rectangle (2.5ex, 1.75ex);
			\end{tikzpicture}
			}
		}{}
	\ifthenelse{\equal{#1}{3}}{
		\raisebox{-0.1em}{
			\begin{tikzpicture}
				\draw [draw = none, fill = violet] (0ex,0ex) rectangle (0.5ex, 0.75ex);
				\draw [draw = none, fill = violet]  (1ex,0ex) rectangle (1.5ex, 1.25ex);
				\draw [draw = none, fill = violet]  (2ex,0ex) rectangle (2.5ex, 1.75ex);
			\end{tikzpicture}
			}
		}{}
	}



























%