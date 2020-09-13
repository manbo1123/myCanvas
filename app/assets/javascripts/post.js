//---------------サイドバーで切り替え---------------//
$(document).on("click", '.side__list', function() {
  $(".side__list").removeClass("active");
  $(".side__list").css("font-weight", "");
  $(".side__list").css("background-color", "");

  $(this).addClass("active");
  $(this).css("font-weight", "bolder");
  $(this).css("background-color", "gray");

  let index = $('.side li').index(this);  // インデックス番号を取得
  if (index == 0) {   //キャンバス
    $(".canvas").css("display", "block");
    $(".post_user").css("display", "block");
    $(".memo_box").css("display", "none");
  } else if (index == 1) {  // ノート
    $(".memo_box").css("display", "block");
    $(".canvas").css("display", "none");
    $(".post_user").css("display", "none");
  } else {  // 画像
    $(".canvas").css("display", "none");
    $(".post_user").css("display", "none");
    $(".memo_box").css("display", "none");
  }
});

//-----------------------タグ入力-----------------------//
$(document).ready(function() {
  $(".post_form__body__form__text.tag").tagit({
    tagLimit:10,   // タグの最大数
    singleField: true,   // タグの一意性
  });
  let tag_count = 10 - $(".tagit-choice").length
  $(".ui-widget-content.ui-autocomplete-input").attr(
    'placeholder','あと' + tag_count + '個登録できます');
})

$(document).on("keyup", '.tagit', function() {
  let tag_count = 10 - $(".tagit-choice").length
  $(".ui-widget-content.ui-autocomplete-input").attr(
  'placeholder','あと' + tag_count + '個登録できます');
})