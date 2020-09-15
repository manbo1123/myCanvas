class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment, presence: true

  def date_ago
    now = Time.now()
    delta_time = now - self.created_at               # 現在時刻- 投稿時刻
    delta_day = Date.today - self.created_at.to_date # 今日 - 投稿日
    if delta_time <= 60 * 60                         # 60min以内
      (delta_time / 60).to_i.to_s + " 分前"
    elsif delta_time  <= 60 * 60 * 24                # 24時間以内
      (delta_time / (60 * 24)).to_i.to_s + " 時間前"
    elsif delta_day <= 14                            # 2週間以内
      delta_day.to_i.to_s + " 日前"
    else                                             # 2週間より前
      self.created_at.strftime("%Y年%m月%d日%a")
    end
  end
end