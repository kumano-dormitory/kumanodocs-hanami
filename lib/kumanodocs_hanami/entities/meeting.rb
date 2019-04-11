class Meeting < Hanami::Entity
  def articles_for_web
    articles_with_nil_number, articles_with_integer_number = articles.partition { |article| article.number.nil? }
    articles_with_integer_number.sort_by! { |article| article.number }
    articles_with_integer_number.concat(articles_with_nil_number)
  end

  def to_tex
    head = <<-EOS
\\documentclass[b5j,10pt]{ujarticle}
\\usepackage{listings}
\\usepackage{spverbatim}
\\usepackage{tocloft}
\\usepackage{here}
\\usepackage[top=5truemm,bottom=15truemm,left=5truemm,right=5truemm]{geometry}

\\lstset{
breaklines=true
1;2802;0c}
\\renewcommand{\\cftsecleader}{\\cftdotfill{\\cftdotsep}}
EOS

    head = head + "\\title{ #{date} ブロック会議 }" + <<-EOS
\\date{}
\\author{}

\\begin{document}
\\maketitle
\\vspace{-10ex}
\\tableofcontents
EOS

    body = articles.map { |article|
      "\\section*{ #{article.title} \\\\ \\ \\  \\normalsize{ 文責：#{article.author_id} } }\n\\addcontentsline{toc}{section}{\\protect\\numberline{} #{article.title} }%\n\\begin{spverbatim}#{article.body}"
    }.join("\n")

    tail = "\n\\end{document}"
    head + body + tail
  end
end
