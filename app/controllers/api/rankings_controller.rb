class Api::RankingsController < ApplicationController
  def daily
    respond_to do |format|
      format.html
      format.json {
        date = params[:date]
        genre_id = params[:genre_id]
        render json: ((Ranking.by_genre_id genre_id).by_created_at date).last.to_json
      }
    end
  end
end
