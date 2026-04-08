% mydocfmt.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mydocfmt}[2025/12/23 Physics Report Class]

% --- オプション処理 ---
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ltjsarticle}}
\ProcessOptions\relax

% --- ベースクラス ---
\LoadClass[a4paper, 11pt]{ltjsarticle}

% --- 必須パッケージ ---
\RequirePackage[top=25mm, bottom=25mm, left=25mm, right=25mm]{geometry}
\RequirePackage{amsmath, amssymb}
\RequirePackage{physics}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
% \RequirePackage{tcolorbox}
\RequirePackage[skins, theorems, breakable]{tcolorbox}
\RequirePackage{graphicx}
\RequirePackage{tikz} 
\RequirePackage[unicode, hidelinks]{hyperref}
\RequirePackage{enumitem}
\RequirePackage{bm}
\usetikzlibrary{calc, fadings}

% PDFのしおり（ブックマーク）の設定だけ有効にしておく
\hypersetup{
    bookmarksnumbered=true,  % しおりに番号を入れる
    bookmarksopen=true       % PDFを開いた時にしおりを展開する
}

% --- 色定義 ---
\definecolor{headerbg}{HTML}{00608D}    % 濃い青
\definecolor{accentcolor}{HTML}{4DABE0} % 水色
\definecolor{highlight}{HTML}{E05A4D}   % 強調色

% --- サブタイトル用変数 ---
\newcommand{\@subtitle}{}
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}

% --- 見出しデザイン ---
\titleformat{\section}
  {\color{headerbg}\Large\bfseries\sffamily} 
  {\thesection} 
  {0.5em}       
  {}            
  [{\color{accentcolor}\titlerule[2pt]}]

\titleformat{\subsection}
  {\color{headerbg}\large\bfseries\sffamily}
  {\thesubsection}
  {0.5em}
  {}
  [{\color{accentcolor!30}\titlerule[0.8pt]}]

\titleformat{\subsubsection}
  {\color{headerbg}\normalsize\bfseries\sffamily} % フォント：濃い青・標準サイズ・太字・ゴシック
  {\thesubsubsection}                             % ラベル：1.1.1
  {0.5em}                                         % ラベルとタイトルの間隔
  {}                                              % タイトル前のコード（なし）
                                                  % [] オプション（下線）は無しでシンプルに

% --- 行間設定 ---
\setlength{\parindent}{1em}
\setlength{\parskip}{0.2em}
\linespread{1.1}

% --- カスタムコマンド ---
% 重要な数式ボックス
\newtcolorbox{importantbox}[1][]{
    colback=white, colframe=black, title=, boxrule=0.5pt, sharp corners, halign=center, #1
}


% 強調コマンド
\newcommand{\redterm}[1]{{\color{highlight}\boldsymbol{#1}}}

% ==================================================
% \maketitle の再定義 (カラフル・ポリゴン・シャープ)
% ==================================================
\renewcommand{\maketitle}{%
    \begin{titlepage}
        \centering
        \vspace*{1.5cm}
        
        % --- タイトル情報 ---
        {\color{accentcolor}\sffamily\large \@date \par} 
        \vspace{0.5cm}
        {\color{headerbg}\sffamily\bfseries\Huge \@title \par}
        \vspace{0.5cm}
        {\color{gray}\sffamily\Large \@subtitle \par}
        
        \vspace{2cm}
        
        % --- カラフルな多角形充填デザイン ---
        \begin{tikzpicture}
            % 1. 切り抜く枠のサイズ (横幅いっぱい使うため広めに設定)
            \def\w{7}   
            \def\h{4.5} 
            
            % クリップ（切り抜き）：角丸(rounded corners)を削除し、直角に
            \clip (-\w, -\h) rectangle (\w, \h);
            
            % グリッド定義
            \foreach \x in {-9,...,9} {
                \foreach \y in {-6,...,6} {
                    % 座標定義: ランダムな揺らぎ
                    \coordinate (N-\x-\y) at (\x*1.2 + rand*0.6, \y*1.2 + rand*0.6);
                }
            }

            % 三角形の描画と塗りつぶし
            \foreach \x [evaluate=\x as \nx using int(\x+1)] in {-9,...,8} {
                \foreach \y [evaluate=\y as \ny using int(\y+1)] in {-6,...,5} {
                    
                    % --- 色のランダム選択ロジック ---
                    % 1〜5の乱数を生成し、それに応じて青系の色を割り当て
                    \pgfmathsetmacro{\cid}{int(random(1,5))}
                    \ifcase\cid
                        \or \colorlet{polycolor}{headerbg}       % 1: 濃い青 (テーマ色)
                        \or \colorlet{polycolor}{accentcolor}    % 2: 水色 (テーマ色)
                        \or \colorlet{polycolor}{cyan!80!blue}   % 3: 鮮やかなシアン
                        \or \colorlet{polycolor}{teal!60!cyan}   % 4: 青緑（ティール）
                        \or \colorlet{polycolor}{blue!60!black}  % 5: 深い群青
                    \fi
                    
                    % --- 三角形 A ---
                    % opacityを高め(0.3~0.8)にして色味をはっきりさせる
                    \fill[polycolor, opacity={0.3 + rnd*0.5}] 
                        (N-\x-\y) -- (N-\nx-\y) -- (N-\x-\ny) -- cycle;
                    % 境界線を白ではなく、ごく薄い同色系または無しにすると色が馴染む
                    % ここではパキッとさせるために薄い白線を維持
                    \draw[white, opacity=0.2, line width=0.3pt] 
                        (N-\x-\y) -- (N-\nx-\y) -- (N-\x-\ny) -- cycle;

                    % --- 色の再選択（隣の三角形も別の色にするため）---
                    \pgfmathsetmacro{\cid}{int(random(1,5))}
                    \ifcase\cid
                        \or \colorlet{polycolor}{headerbg}
                        \or \colorlet{polycolor}{accentcolor}
                        \or \colorlet{polycolor}{cyan!80!blue}
                        \or \colorlet{polycolor}{teal!60!cyan}
                        \or \colorlet{polycolor}{blue!60!black}
                    \fi

                    % --- 三角形 B ---
                    \fill[polycolor, opacity={0.3 + rnd*0.5}] 
                        (N-\nx-\y) -- (N-\nx-\ny) -- (N-\x-\ny) -- cycle;
                    \draw[white, opacity=0.2, line width=0.3pt] 
                        (N-\nx-\y) -- (N-\nx-\ny) -- (N-\x-\ny) -- cycle;
                }
            }
            
        \end{tikzpicture}
        
        \vfill
        
        % --- 著者名 ---
        {\Large \sffamily \@author \par}
        \vspace{2cm}
    \end{titlepage}
    \setcounter{page}{1}
}

% ==================================================
% 定理・定義・例 環境のデザイン定義 (フラットスタイル)
% ==================================================

% --- 共通スタイル定義 ---
% タイトルバーを作らず、本文の先頭にタイトルを埋め込むスタイル
\tcbset{
    flatstyle/.style={
        enhanced,
        breakable,          % ページまたぎ許可
        frame hidden,       % 枠線を消す
        sharp corners,      % 角を直角に
        left=3mm, right=3mm, top=3mm, bottom=3mm, % 内側の余白
        detach title,       % タイトルをボックスから分離
        before upper={\tcbtitle\par}, % 本文の前にタイトルと空白を挿入
        fonttitle=\bfseries\sffamily,  % タイトルのフォント
        fontupper=\normalfont,         % 本文のフォント
    }
}

% --- 青系環境（定理・補題・定義） ---
% 背景：薄い水色 (accentcolor!10)
% 左線：濃い青 (headerbg)
% 文字：濃い青 (headerbg)
\tcbset{
    bluestyle/.style={
        flatstyle,
        colback=accentcolor!10!white,    % 背景色
        coltitle=headerbg,               % タイトル文字色
        borderline west={3pt}{0pt}{headerbg}, % 左側の太線
    }
}

% --- グレー系環境（例） ---
% 背景：薄いグレー
% 左線：濃いグレー
\tcbset{
    graystyle/.style={
        flatstyle,
        colback=gray!10!white,
        coltitle=gray!50!black,
        borderline west={3pt}{0pt}{gray},
    }
}

% --- 注意ボックス ---
\newtcolorbox{rem}[1][]{
    flatstyle,
    colback=highlight!7!white,
    coltitle=highlight!80!black,
    borderline west={3pt}{0pt}{highlight},
    title=\textbf{\sffamily 注意},
    #1
}

% --- 環境の作成 ---

% 1. 定理 (Theorem)
\newtcbtheorem[number within=section]{thm}{定理}{
    bluestyle
}{thm}

% 2. 補題 (Lemma)
% 定理と同じカウンタ(thm)を使用する場合
\newtcbtheorem[number within=section, use counter from=thm]{lemma}{補題}{
    bluestyle
}{lem}

% 3. 定義 (Definition)
\newtcbtheorem[number within=section]{defn}{定義}{
    bluestyle
}{def}

% 4. 例 (Example)
\newtcbtheorem[number within=section]{ex}{例}{
    graystyle
}{ex}

% 5. 命題 (Proposition)
\newtcbtheorem[number within=section]{prop}{命題}{
    bluestyle
}{prop}

% 6. 演習問題 (Exercise)
\newtcbtheorem[number within=section]{exercise}{演習問題}{
    bluestyle
}{exer}

% ==================================================
% 証明 (Proof) 環境
% ==================================================
% 背景なし・枠なし・全体インデント・タイトルだけ突き出し
\newtcolorbox{proof}{
    blanker,              % 枠も背景もなし
    breakable,            % ページまたぎ許可
    left skip=2em,        % 全体を2文字分右にインデント
    parbox=false,         % 通常の段落として扱う
    % タイトル部分: -2em戻って「証明」を表示
    before upper={\hspace*{-2em}\textbf{\quad\sffamily 証明}\quad}, 
    % 末尾: QED記号
    after upper={\hfill\ensuremath{\square}} 
}

% ==================================================
% 解答 (Answer) 環境
% ==================================================
% 背景なし・枠なし・全体インデント・タイトルだけ突き出し
\newtcolorbox{answer}{
    blanker,              % 枠も背景もなし
    breakable,            % ページまたぎ許可
    left skip=2em,        % 全体を2文字分右にインデント
    parbox=false,         % 通常の段落として扱う
    % タイトル部分: -2em戻って「解答」を表示
    before upper={\hspace*{-2em}\textbf{\quad\sffamily 解答}\quad}, 
    % 末尾: QED記号
    after upper={\hfill\ensuremath{\square}} 
}

% ==================================================
% 目次 (TOC) のデザイン設定
% ==================================================

% 目次自体のタイトル（「目次」）のデザイン変更
% 既存の \section デザインが適用されますが、微調整したい場合はここで指定
\renewcommand{\tableofcontents}{%
    \section*{\contentsname}
    \@starttoc{toc}
	\clearpage
}

% --- セクション (Section) の行デザイン ---
% 特徴: 大きめの文字、青色、下線付きで区切りを明確に
\titlecontents{section}
  [0em]                                   % 左のインデント
  {\addvspace{1.2em}\sffamily\bfseries\color{headerbg}\large} % 上部の空きとフォント設定
  {\thecontentslabel\quad}                % ラベル（番号） "1 "
  {}                                      % 番号なしの場合
  {\hfill\contentspage}                   % ページ番号を右端に
  [\titleline{\color{accentcolor!30}\titlerule[0.8pt]}] % 下に薄い水色のラインを引く

% --- サブセクション (Subsection) の行デザイン ---
% 特徴: インデントして配置、細い点線リーダー
\titlecontents{subsection}
  [3em]                                   % セクションより右にインデント
  {\addvspace{0.2em}\sffamily\normalsize} % フォント設定
  {\thecontentslabel\quad}                % ラベル "1.1 "
  {}                                      % 番号なしの場合
  {\titlerule*[0.5pc]{.}\contentspage}    % 点線リーダー (...) とページ番号

\endinput
