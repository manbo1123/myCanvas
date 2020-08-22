module ApplicationHelper
  require "redcarpet"

  def markdown(text)
    options = {
      filter_html:     true,     # htmlを出力しない
      hard_wrap:       true,     # マークダウン中の空行をhtmlに置き換える
      space_after_headers: true, # # と文字の間にスペースが必要
    }

    extensions = {
      autolink:           true,  # <>で囲まれていなくてもリンクを認識
      no_intra_emphasis:  true,  # 単語中の強調を強調と認識しない
      fenced_code_blocks: true,  # フェンスのあるコードブロックを認識
      strikethrough:      true,  # ~ 2つで取り消し線
      superscript:        true,  # ^ の後ろが上付き文字
      tables:             true,  # テーブルを認識
      underline:          true,  # 斜線(* *)
      highlight:          true,  # ハイライト(== ==)
      quote:              true,  # 引用符(" ")
      footnotes:          true,  # 脚注( ^[1] )
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
