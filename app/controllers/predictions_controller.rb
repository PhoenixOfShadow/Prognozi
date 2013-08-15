class PredictionsController < ApplicationController

  def predict
    if params[:tournament_id].blank?
      @tournament_empty = true
      @tournaments = Tournament.all
    else
      @tournament_empty = false
      @tournament = Tournament.find(params[:tournament_id])
      @matches = Match.where(:tournament_id => @tournament.id)
    end
  end

  def submit
    params[:prediction].each do |k, v|
      score = ScorePrediction.find_or_create_by_match_id(k)
      score.user_id = current_user.id
      score.match_id = k
      score.host_score = v[:host_result]
      score.guest_score = v[:guest_result]
      score.result = v[:sign_select]
      score.save
    end
    redirect_to :back
  end
end

# Rails server cmd log

# "prediction"=>
#   {
#     "1"=>{"host_result"=>"host1", "guest_result"=>"guest1", "sign_select"=>"1"}, 
#     "2"=>{"host_result"=>"host2", "guest_result"=>"guest2", "sign_select"=>"x"}, 
#     "3"=>{"host_result"=>"host3", "guest_result"=>"guest3", "sign_select"=>"2"}
#   }, 

# params[:prediction].each |k, v| do
#   score = ScorePrediction.new
#   score.user_id = current_user.id
#   score.match_id = k
#   score.host_sore = v[:host_result]
#   score.guest_result = v[:guest_result]
#   score.sign_select = v[:sign_select]
# end
