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

  // Ajaxで、タグ一覧を取得
  let input = $(".ui-widget-content.ui-autocomplete-input").val();  // 変数inputに、入力した値を格納
  $.ajax({
    type: 'GET',
    url: 'get_tag_search',
    data: { key: input },
    dataType: 'json'
  })
  .done(function(data){
    if(input.length) {
      let tag_list = [];
      data.forEach(function(tag) {
        tag_list.push(tag.name);
      });
      $(".post_form__body__form__text.tag").tagit({
        availableTags: tag_list
      });
    }
  })
});
//-----------------------画像投稿-----------------------//
// 次の画像投稿用のinputタグ
let nextInput = (num, index) => {
  let html = `<div class="image_box__input__dropbox" data-index="${num}" index="${index}">
                <input class="image_box__input__default" type="file" multiple= "multiple" accept="image/*"></input>
              </div>`;
  return html;
}
//プレビュー用のimgタグ
let previewImages = (src)=> {
  let html = `<div class="preview preview_unsave">
                <img src="${src}">
                <div class="image_delete_btn">削除</div>
              </div>`;
  return html;
}
$(document).on('change','input[type= "file"]', function(e) {
  let reader = new FileReader();  //画像の読み込み
  let file = e.target.files[0];   //inputから1つ目のfileを取得
  reader.readAsDataURL(file);     //画像のURL取得

  let preview_count = $('.preview').length;
  let preview_unsave_count = $('.preview_unsave').length;
  let preview_save_count = $('.preview_saved').length;
  let preview_saved_count = $('.hidden-destroy').length;

  reader.onload = function(e) {   //読み込み完了で、プレビュー表示
    // 最大登録枚数:5枚まで
    if ($('.preview').length <= 4){
      $('.previews').append(previewImages(e.target.result));
      $('.image_box__input__dropbox').removeClass('image_box__input__dropbox').addClass('image-preview').appendTo('.image_box__input');
      $('.image_box__input').prepend(nextInput(preview_count + 1, preview_unsave_count + 1));
    } 
    if ($('.preview').length >= 5) {  // 5枚目なら、inputタグを表示しない
      $('.image_box').css('display', 'none');
    }
    //識別のための管理番号をつけ直す
    $('.preview').each(function(i) {
      $(this).attr('data-index', (i+1));
    });
    $('.preview_unsave').each(function(i) {
      $(this).attr('index', (i+1));
    });
    $('.image-preview').each(function(i) {
      $(this).attr('index', (i+1));
      $(this).attr('data-index', (preview_save_count+i+1));
      $(this).children().attr('name', "post[imgs_attributes][" + (preview_saved_count+i) + "][src]");
      $(this).children().attr('data-index', (i+1));
      $(this).children().attr('id', "product_images_attributes_"+(preview_saved_count+i)+"_name");
    });
  };
});
$(document).on("click",'.image_delete_btn', function() {
  let targetIndex = $(this).parent().data("name");
  $(this).parent().remove();
  // 画像入力欄が0個にならないようにする
  if (targetIndex >= 0) {
    let hiddenCheck = $(`input[data-index="${targetIndex}"].hidden-destroy`);
    hiddenCheck.prop('checked', true)
  }
  let preview_num = $(this).parent().attr('index');
  let preview_total_num = $(this).parent().attr('data-index');
  let preview_count = $('.preview').length;
  let preview_unsave_count = $('.preview_unsave').length;
  let preview_save_count = $('.preview_saved').length;
  let preview_saved_count = $('.hidden-destroy').length;

  if (preview_num >= 0) {
    $('.image-preview[index ='+preview_num+']').remove();
  }
  //管理番号をつけ直す
  $('.preview').each(function(i) {
    $(this).attr('data-index', (i+1));
  });
  $('.preview_unsave').each(function(i) {
    $(this).attr('index', (i+1));
  });
  $('.image-preview').each(function(i) {
    $(this).attr('index', (i+1));
    $(this).attr('data-index', (preview_save_count+i+1));
    $(this).children().attr('name', "post[imgs_attributes][" + (preview_saved_count+i+1) + "][src]");
    $(this).children().attr('data-index', (i+1));
  });
  if (preview_count == 4 ) {
    $('.image_box__input').prepend(nextInput(preview_count + 1, preview_unsave_count + 1));
    $('.image_box').css('display', 'block');
  }
});
// ページ更新時に画像を既に5枚登録済みなら、inputタグを非表示にする
window.onload = function () {
  //保存済み画像数
  let image_num = $('.preview').length;
  if (image_num >= 5) {
    $('.image_box').css('display', 'none');
    $('.image_box').find('.image_box__input__dropbox').remove();
  }
}
