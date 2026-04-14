% myrepofmt.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myrepofmt}[2026/04/07 Formal Report Class]

% --- オプション処理 ---
\newif\if@usecoverpage
\@usecoverpagetrue % デフォルトは表紙を独立ページにする

\DeclareOption{titlepage}{\@usecoverpagetrue}
\DeclareOption{notitlepage}{\@usecoverpagefalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ltjsarticle}}
\ProcessOptions\relax

% --- ベースクラス ---
\LoadClass[a4paper, 11pt]{ltjsarticle}

% --- 必須パッケージ ---
\RequirePackage[top=30mm, bottom=30mm, left=25mm, right=25mm]{geometry}
\RequirePackage{amsmath, amssymb}
\RequirePackage{physics}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage[skins, theorems, breakable]{tcolorbox}
\RequirePackage{graphicx}
\RequirePackage[unicode, hidelinks]{hyperref}
\RequirePackage{enumitem}
\RequirePackage{bm}

% PDFのしおり（ブックマーク）の設定
\hypersetup{
    bookmarksnumbered=true,
    bookmarksopen=true
}

% --- 色定義 ---
\definecolor{primary}{HTML}{000000}   % 黒
\definecolor{secondary}{HTML}{333333} % ダークグレー

% --- 変数の初期化（日付を空にする設定を含む） ---
\let\@date\@empty
\newcommand{\@subtitle}{}
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}

% --- 見出しデザイン ---
\titleformat{\section}
  {\color{primary}\Large\bfseries\rmfamily} 
  {\thesection} 
  {1em}      
  {}            
  [\vspace{2pt}{\color{primary}\titlerule[0.5pt]}]

\titleformat{\subsection}
  {\color{primary}\large\bfseries\rmfamily}
  {\thesubsection}
  {1em}
  {}

\titleformat{\subsubsection}
  {\color{primary}\normalsize\bfseries\rmfamily}
  {\thesubsubsection}
  {1em}
  {}

% --- 行間設定 ---
\setlength{\parindent}{1em}
\setlength{\parskip}{0pt}
\linespread{1.15}

% --- カスタムコマンド ---
\newcommand{\redterm}[1]{\textbf{#1}}

% ==================================================
% \maketitle の再定義 (日付の有無・表紙切替対応)
% ==================================================
\renewcommand{\maketitle}{%
    \if@usecoverpage
        % 独立した表紙ページ
        \begin{titlepage}
            \null\vfil
            \begin{center}
                \ifx\@date\@empty\else
                    {\Large \rmfamily \@date \par} 
                    \vspace{2cm}
                \fi
                {\rule{\linewidth}{1pt}\par}
                \vspace{0.5cm}
                {\huge \bfseries \rmfamily \@title \par}
                \vspace{0.3cm}
                \ifx\@subtitle\@empty\else
                    {\Large \rmfamily \@subtitle \par}
                \fi
                \vspace{0.5cm}
                {\rule{\linewidth}{1pt}\par}
                \vspace{3cm}
                {\LARGE \rmfamily \@author \par}
            \end{center}
            \vfil\null
        \end{titlepage}
        \setcounter{page}{1}
    \else
        % 先頭ページの上部に組み込み
        \begin{center}
            {\rule{\linewidth}{1pt}\par}
            \vspace{0.3cm}
            \ifx\@date\@empty\else
                {\large \rmfamily \@date \par} 
                \vspace{0.3cm}
            \fi
            {\huge \bfseries \rmfamily \@title \par}
            \vspace{0.2cm}
            \ifx\@subtitle\@empty\else
                {\large \rmfamily \@subtitle \par}
                \vspace{0.2cm}
            \fi
            {\Large \rmfamily \@author \par}
            \vspace{0.3cm}
            {\rule{\linewidth}{1pt}\par}
        \end{center}
        \vspace{0.5cm}
    \fi
}

% ==================================================
% 定理・定義・環境のデザイン定義
% ==================================================
\tcbset{
    formalstyle/.style={
        enhanced, breakable, frame hidden, colback=white, coltitle=primary,
        fonttitle=\bfseries\rmfamily, fontupper=\normalfont\rmfamily,
        top=2mm, bottom=2mm, left=0mm, right=0mm,
        borderline north={1pt}{0pt}{primary},
        borderline south={1pt}{0pt}{primary},
        detach title, before upper={\tcbtitle\quad}, sharp corners,
    },
    lightstyle/.style={
        enhanced, breakable, frame hidden, colback=white, coltitle=secondary,
        fonttitle=\bfseries\rmfamily, fontupper=\normalfont\rmfamily,
        top=2mm, bottom=2mm, left=0mm, right=0mm,
        borderline north={0.5pt}{0pt}{secondary},
        borderline south={0.5pt}{0pt}{secondary},
        detach title, before upper={\tcbtitle\quad}, sharp corners,
    },
    noqedsymbol/.style={after upper={}}
}

\newtcolorbox{rem}[1][]{
    enhanced, breakable, frame hidden, colback=white,
    borderline west={2pt}{0pt}{secondary},
    top=1mm, bottom=1mm, left=3mm, right=0mm,
    fonttitle=\bfseries\rmfamily, coltitle=primary,
    title={注意}, detach title, before upper={\tcbtitle\quad},
    #1
}

\newtcbtheorem[number within=section]{thm}{定理}{formalstyle}{thm}
\newtcbtheorem[number within=section, use counter from=thm]{lemma}{補題}{formalstyle}{lem}
\newtcbtheorem[number within=section]{defn}{定義}{formalstyle}{def}
\newtcbtheorem[number within=section]{ex}{例}{lightstyle}{ex}
\newtcbtheorem[number within=section]{prop}{命題}{formalstyle}{prop}
\newtcbtheorem[number within=section]{exercise}{演習問題}{lightstyle}{exer}

\newtcolorbox{customformal}[2][]{formalstyle, title={#2}, #1}
\newtcolorbox{customlight}[2][]{lightstyle, title={#2}, #1}
\newtcolorbox{customproof}[2][]{
    blanker, breakable, top=2mm, bottom=2mm,
    before upper={\textbf{\rmfamily #2}\quad}, #1
}

\newtcolorbox{proof}{
    blanker, breakable, top=2mm, bottom=2mm,
    before upper={\textbf{\rmfamily 証明}\quad},
    after upper={\hfill\ensuremath{\blacksquare}}
}

\newtcolorbox{answer}[1][]{
    blanker, breakable, top=2mm, bottom=2mm,
    before upper={\textbf{\rmfamily 解答}\quad},
    after upper={\hfill\ensuremath{\square}},
    #1
}

% ==================================================
% 目次 (TOC) のデザイン設定
% ==================================================
\renewcommand{\tableofcontents}{%
    \section*{\contentsname}
    \@starttoc{toc}
    \clearpage
}

\titlecontents{section}
  [0em]
  {\addvspace{1em}\rmfamily\bfseries\large}
  {\thecontentslabel\quad}
  {}
  {\hfill\contentspage}

\titlecontents{subsection}
  [2em]
  {\addvspace{0.1em}\rmfamily}
  {\thecontentslabel\quad}
  {}
  {\titlerule*[0.5pc]{.}\contentspage}

\endinput
